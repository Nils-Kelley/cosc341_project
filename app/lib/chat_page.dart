import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_provider.dart';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  final _authProvider = AuthProvider();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final String month = DateFormat.MMM().format(dateTime);
    final String day = DateFormat.d().format(dateTime);
    final String year = DateFormat.y().format(dateTime);
    final String suffix = getDaySuffix(int.parse(day));
    return '$month $day$suffix, $year';
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String formatTimestamp(String timestamp) {
    final now = DateTime.now();
    final messageTime = DateTime.parse(timestamp);

    final difference = now.difference(messageTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes min ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hours ago';
    } else {
      final dateFormatter = DateFormat('MMM d, y');
      return dateFormatter.format(messageTime);
    }
  }

  Future<void> _fetchMessages() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final httpClient = createHttpClient();
    try {
      final response = await httpClient.get(
        Uri.parse('https://10.0.0.201:5050/forum/get-messages'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${authProvider.token}',
        },
      );

      if (response.statusCode == 200) {
        final messageList = json.decode(response.body) as List;
        setState(() {
          _messages = messageList.map((message) => {
            'username': message['username'],
            'text': message['text'],
            'timestamp': formatTimestamp(message['timestamp']),
            'isMe': message['user_id'] == _authProvider.getCurrentUserID(),
          }).toList();
        });
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    } catch (e) {
      print('Error in Fetching Messages: $e');
    }
  }

  Future<void> _sendMessage(String messageText) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (messageText.isNotEmpty) {
      final httpClient = createHttpClient();
      try {
        final response = await httpClient.post(
          Uri.parse('https://10.0.0.201:5050/forum/post-message'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ${authProvider.token}',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode({'text': messageText}),
        );

        if (response.statusCode == 201) {
          _fetchMessages();
        }
      } catch (e) {
        print('Error in Sending Message: $e');
      }
      _messageController.clear();
    }
  }

  http.Client createHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
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
          Text(
            message['text'],
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            message['timestamp'],
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: message['isMe']
          ? null
          : Icon(
        Icons.arrow_forward,
        color: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.blue,
        title: Text(
          'Community Forum',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.home), // Home icon
            onPressed: () {
              // Navigate to the HomeScreen class
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              color: Color(0xFFF5F5F5),
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (ctx, index) {
                  return _buildMessageTile(index);
                },
              ),
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
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
