import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [
    {
      'username': 'John Doe',
      'text': 'Has anyone tried the Gatherer restaurant downtown?',
      'isMe': false,
      'timestamp': '10:00 AM',
    },
    {
      'username': 'Alice Smith',
      'text': 'I\'ve been there, and it\'s fantastic!',
      'isMe': true,
      'timestamp': '10:05 AM',
    },
    {
      'username': 'Bob Johnson',
      'text': 'I went there last week. The food was amazing!',
      'isMe': false,
      'timestamp': '10:10 AM',
    },
    {
      'username': 'Eva Green',
      'text': 'Im planning to visit Gatherer soon. Any recommendations?',
      'isMe': false,
      'timestamp': '10:15 AM',
    },
    {
      'username': 'Charlie Brown',
      'text': 'You should try their pasta dishes. They are excellent!',
      'isMe': true,
      'timestamp': '10:20 AM',
    },
    {
      'username': 'Grace Miller',
      'text': 'Im a vegetarian. Do they have good vegetarian options?',
      'isMe': false,
      'timestamp': '10:25 AM',
    },
    {
      'username': 'Daniel Lee',
      'text': 'Yes, they have some delicious vegetarian options!',
      'isMe': true,
      'timestamp': '10:30 AM',
    },
    // Add more messages and users here...
  ];

  void _sendMessage(String messageText) {
    if (messageText.isNotEmpty) {
      setState(() {
        _messages.add({
          'username': 'Kelowna Local', // Add the sender's username here
          'text': messageText,
          'isMe': true,
          'timestamp': _getCurrentTime(),
        });
        _messageController.clear();
      });
    }
  }

  String _getCurrentTime() {
    final DateTime now = DateTime.now();
    final String formattedTime =
        '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  Widget _buildMessageTile(int index) {
    final message = _messages[index];
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          message['username'][0],
          style: TextStyle(fontSize: 16),
        ),
      ),
      title: Text(
        message['username'],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message['text']),
          SizedBox(height: 4),
          Text(
            message['timestamp'],
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: message['isMe'] ? null : SizedBox(width: 36),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2, // Add elevation to the AppBar
        backgroundColor: Colors.white, // Set background color to white
        title: Text(
          'Community Forum',
          style: TextStyle(
            color: Colors.blue, // Set title color to blue
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.blue), // Set icon color to blue
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                return _buildMessageTile(index);
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
