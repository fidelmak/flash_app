import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedinUser;

class ChatScreen extends StatefulWidget {
  static String id = "chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void messagesStream() async {
  //   await for (var snapshots in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshots.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  // Future getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  //messagesStream();
                  //Implement logout functionality
                  _auth.signOut();
                  Navigator.pop(context);
                }),
          ],
          title: Text('⚡️ChatapZ'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('timeStamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  List<MessageBubble> messageWidgets = [];

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                      ),
                    );
                  }
                  final messages = snapshot.data?.docs.reversed;
                  for (var message in messages!) {
                    final data = message.data() as Map;
                    final messageText = data['text'];
                    final messageSender = data['sender'];
                    //final Timestamp messageTime = message['timeStamp'];

                    final currentUser = loggedinUser!.email;
                    if (currentUser == messageSender) {
                      // this message is from the logged in user
                    }

                    final messageWidget = MessageBubble(
                      sender: messageSender,
                      text: messageText,
                      isMe: currentUser == messageSender,
                      //time: messageTime,
                    );
                    messageWidgets.add(messageWidget as MessageBubble);
                  }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: messageWidgets,
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //Implement send functionality.
                      _firestore.collection('messages').add({
                        'sender': loggedinUser!.email,
                        'text': messageText,
                        'timeStamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
  });
  final String sender;
  final String text;
  final bool isMe;
  //final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
              style: TextStyle(
                fontSize: 18,
              )),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: isMe
                ? const Color.fromARGB(255, 20, 62, 82)
                : Color.fromARGB(255, 177, 154, 87),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
