require('dotenv').config();
const express = require('express');
const session = require('express-session');
const path = require('path');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const fs = require('fs');
const morgan = require('morgan');
const multer = require('multer');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const https = require('https');
const rateLimit = require('express-rate-limit');
const sharp = require('sharp'); // Import Sharp library for image processing


// Read HTTPS certificates
const privateKey = fs.readFileSync('key.pem', 'utf8');
const certificate = fs.readFileSync('cert.pem', 'utf8');
const passphrase = 'N3wP@ssPhr4s3!2023'; // Replace with your actual passphrase

const credentials = { key: privateKey, cert: certificate, passphrase: passphrase };

const app = express();
const cors = require('cors');
// Environment variables
const sessionSecret = process.env.SESSION_SECRET;
const dbHost = process.env.DB_HOST;
const dbUser = process.env.DB_USER;
const dbPassword = process.env.DB_PASSWORD;
const dbName = process.env.DB_NAME;
const dbPort = process.env.DB_PORT || 3306;

// Express setup
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(
  session({
    secret: sessionSecret,
    resave: false,
    saveUninitialized: true,
  })
);

// CORS configuration
app.use(cors({
  origin: 'http://localhost:3000', // Allow requests from the React app
  methods: 'GET,POST,PUT,DELETE',
  credentials: true // Allow cookies/session to be sent
}));

// Storage and Multer setup
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // Specify the directory where images will be stored
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    const fileExtension = file.originalname.split('.').pop();
    cb(null, uniqueSuffix + '.' + fileExtension); // Adjust the filename
  },
});

const upload = multer({ storage: storage });

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 3306,
  connectionLimit: 100,
});


// Utility functions
function executeQuery(query, values) {
  return new Promise((resolve, reject) => {
    pool.query(query, values, (err, result) => {
      if (err) {
        reject(err);
      } else {
        resolve(result);
      }
    });
  });
}

function generateToken(userId) {
  return jwt.sign({ userId }, process.env.JWT_SECRET, {
    expiresIn: '1h',
  });
}
function verifyToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  if (!token) {
    return res.status(403).json({ message: 'Missing token' });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(403).json({ message: 'Invalid or expired token' });
    }
    req.userId = decoded.userId;
    next();
  });
}


// Rate limiting middleware
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

// Apply rate limiting
app.use('/refresh', limiter);

// Function to generate a refresh token
function generateRefreshToken(userId) {
  // Including other metadata like IP, User-Agent can improve security
  return jwt.sign({ userId }, process.env.JWT_REFRESH_SECRET, {
    expiresIn: '7d',
  });
}

const storeRefreshToken = async (userId, token) => {
  try {
    await executeQuery('INSERT INTO refresh_tokens (user_id, token, expiry) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 7 DAY))', [userId, token]);
  } catch (err) {
    console.error(err);
  }
};

const validateRefreshToken = async (token) => {
  try {
    const result = await executeQuery('SELECT * FROM refresh_tokens WHERE token = ? AND expiry > NOW()', [token]);
    return result.length > 0;
  } catch (err) {
    console.error(err);
    return false;
  }
};

// Route to refresh tokens
app.post('/refresh', async (req, res) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(403).json({ message: 'Missing token' });
  }

  // Check if refresh token is valid
  const isValidRefreshToken = await validateRefreshToken(token);
  if (!isValidRefreshToken) {
    return res.status(403).json({ message: 'Invalid refresh token' });
  }

  jwt.verify(token, process.env.JWT_REFRESH_SECRET, async (err, decoded) => {
    if (err) {
      return res.status(403).json({ message: 'Invalid or expired token' });
    }

    const userId = decoded.userId;

    // Extra checks like user verification, IP address matching, etc.
    // You can implement these checks here.

    // Generate new access and refresh tokens
    const newAccessToken = generateToken(userId);
    const newRefreshToken = generateRefreshToken(userId);

    // Store the new refresh token in the database
    await storeRefreshToken(userId, newRefreshToken);

    return res.status(200).json({
      access_token: newAccessToken,
      refresh_token: newRefreshToken,
    });
  });
});



// Route for user registration
app.post('/register', upload.single('profile_image'), function (req, res) {
  const { username, fullname, email, password } = req.body;
  const profile_image = req.file ? req.file.filename : null;

  bcrypt.hash(password, 10, function(err, hashedPassword) {
    if(err) {
      console.error(err);
      return res.status(500).json({ message: 'An error occurred during user registration.', error: err });
    }

    const query = 'INSERT INTO users (username, fullname, email, password, registration_date, last_login, verified) VALUES (?, ?, ?,  ?, NOW(), NOW(), 0)';
    const values = [username, username, email, hashedPassword];

    executeQuery(query, values)
      .then((result) => {
        req.session.userId = result.insertId;
        const token = generateToken(req.session.userId);
        return res.status(201).json({ message: 'Registration successful', userId: req.session.userId, token });  // JSON Response
      })
      .catch((err) => {
        console.error(err);
        return res.status(500).json({ message: 'An error occurred during user registration.', error: err });
      });
  });
});

// Route for user login
app.post('/login', function (req, res) {
  const { identifier, password } = req.body;

  const query = 'SELECT * FROM users WHERE email = ? OR username = ?';
  const values = [identifier, identifier];
  executeQuery(query, values)
    .then((result) => {
      if (result.length === 0) {
        return res.status(401).json({ message: 'Invalid email/username or password.' });
      }

      // Check hashed password
      bcrypt.compare(password, result[0].password, function(err, isMatch) {
        if (err) {
          console.error(err);
          return res.status(500).json({ message: 'An error occurred during user login.' });
        }

        if (!isMatch) {
          return res.status(401).json({ message: 'Invalid email/username or password.' });
        }

        req.session.userId = result[0].id;
        const token = generateToken(req.session.userId);
        return res.status(200).json({ message: 'Login successful', userId: req.session.userId, token }); // JSON response for success
      });
    })
    .catch((err) => {
      console.error(err);
      return res.status(500).json({ message: 'An error occurred during user login.' });
    });
});


app.post('/logout', function (req, res) {
  req.session.destroy(function (err) {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: 'An error occurred during user logout.', success: false });
    }

    return res.status(200).json({ message: 'User successfully logged out.', success: true });
  });
});

app.get('/user', verifyToken, function (req, res) {
  const userId = req.userId;
  const query = 'SELECT * FROM users WHERE id = ?';
  executeQuery(query, [userId])
    .then((result) => {
      if (result.length === 0) {
        return res.status(404).json({ message: 'User not found.' });
      }
      return res.status(200).json(result[0]);
    })
    .catch((err) => {
      console.error(err);
      return res.status(500).json({ message: 'An error occurred while fetching user details.' });
    });
});




// Add a new route for getting the current user's ID
app.get('/get-current-user', verifyToken, async (req, res) => {
  try {
    const userId = req.userId;
    res.status(200).json({ userId });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'An error occurred while getting the current user ID' });
  }
});
app.get('/conversation/:conversationId/messages', verifyToken, async (req, res) => {
  const conversationId = req.params.conversationId;

  try {
    const messagesQuery = `
      SELECT m.*, u.username AS senderUsername, roAgg.offerPrice, roAgg.offerUnit
      FROM messages m
      INNER JOIN users u ON m.sender_id = u.id
      LEFT JOIN (
        SELECT cla.conversation_id, MAX(ro.price) AS offerPrice, MAX(ro.unit) AS offerUnit
        FROM conversation_listing_association cla
        LEFT JOIN listings l ON cla.listing_id = l.id
        LEFT JOIN rental_offers ro ON l.id = ro.listing_id AND ro.status = 'Pending'
        GROUP BY cla.conversation_id
      ) AS roAgg ON m.conversation_id = roAgg.conversation_id
      WHERE m.conversation_id = ?
      ORDER BY m.sent_at ASC`;

    const messages = await executeQuery(messagesQuery, [conversationId]);
    console.log('Fetched messages successfully:', messages);
    res.status(200).json({ message: 'Fetched messages successfully', messages });
  } catch (err) {
    console.error('Error fetching messages:', err);
    res.status(500).json({ message: 'An error occurred while fetching messages' });
  }
});



app.put('/update-profile', verifyToken, async (req, res) => {
  const userId = req.userId;
  const { updatedBio, updatedUsername } = req.body;

  try {
    console.log('Updating profile for user:', userId);
    console.log('Updated Bio:', updatedBio);
    console.log('Updated Username:', updatedUsername);

    // Check if the updated username already exists
    if (updatedUsername) {
      const existingUsernameQuery = 'SELECT id FROM users WHERE username = ? AND id <> ?';
      const existingUsernameResult = await executeQuery(existingUsernameQuery, [updatedUsername, userId]);

      if (existingUsernameResult.length > 0) {
        // Username already exists, send an error response
        console.log('Username already exists. Please choose a different one.');
        return res.status(400).json({ message: 'Username already exists. Please choose a different one.' });
      }
    }

    // Update the user's bio and/or username in the database
    let updateProfileQuery = 'UPDATE users SET';
    const params = [];

    if (updatedBio) {
      updateProfileQuery += ' bio = ?,';
      params.push(updatedBio);
    }

    if (updatedUsername) {
      updateProfileQuery += ' username = ?,';
      params.push(updatedUsername);
    }

    // If no fields are provided for update, return an error
    if (params.length === 0) {
      return res.status(400).json({ message: 'No fields provided for update.' });
    }

    // Remove the trailing comma
    updateProfileQuery = updateProfileQuery.slice(0, -1);

    // Add the WHERE clause
    updateProfileQuery += ' WHERE id = ?';
    params.push(userId);

    console.log('Executing SQL Query:', updateProfileQuery, 'with params:', params);

    // Execute the SQL query and handle errors
    await executeQuery(updateProfileQuery, params);

    console.log('Profile updated successfully');
    res.status(200).json({ message: 'Profile updated successfully' });
  } catch (err) {
    console.error(err);
    console.log('An error occurred while updating the profile.');

    // Handle specific SQL syntax error
    if (err.code === 'ER_PARSE_ERROR') {
      return res.status(400).json({ message: 'Invalid update parameters. Please check your input.' });
    }

    res.status(500).json({ message: 'An error occurred while updating the profile.' });
  }
});


// Start the server
const port = process.env.PORT || 5050;
const httpsServer = https.createServer(credentials, app);
httpsServer.listen(port, () => {
  console.log(`HTTPS Server running on port ${port}`);
});
//PEM passphrase: N3wP@ssPhr4s3!2023