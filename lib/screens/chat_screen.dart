import 'package:flutter/material.dart';
import 'package:have_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

String emailAddressOfCurrentUser = '';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textAreaController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String message = '';
  bool isMe = false;
  void getAuthUser() async {
    try {
      final currentUser = await _auth.currentUser!;
      if (currentUser != null) {
        emailAddressOfCurrentUser = currentUser.email.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  //TODO These two function as the best one of example code
  // void getMessage() async{
  // final messageStored = await _firestore.collection('messageData').get();
  // for(var messageItem in messageStored.docs){
  //  print(messageItem.data());
  // }
  // }
  // void snapChat() async {
  //   await for (var snapchat
  //       in _firestore.collection('messageData').snapshots()) {
  //     for (var message in snapchat.docs) {
  //       print(message.data());
  //     }
  //   }
  // }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getAuthUser();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              dispose();
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStrem(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textAreaController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textAreaController.clear();
                      _firestore.collection('messageData').add(
                        {
                          'sender': emailAddressOfCurrentUser,
                          'message': message,
                          'timestamp':
                              DateTime.now() // TODO CHECK TIME FORMATE;
                        },
                      );
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
        ),
      ),
    );
  }
}

class MessageStrem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messageData').snapshots(),
        builder: (context, snapshot) {
          List<BubleMessage> messageWidget = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.teal,
                strokeWidth: 30.0,
              ),
            );
          }
          // use null check;
          final messages = snapshot.data!.docs;
          for (var displayMessage in messages) {
            final sender = displayMessage['sender'];
            final message = displayMessage['message'];
            final timeStamp = displayMessage['timestamp'];
            final thisUser = emailAddressOfCurrentUser;
            final messagesWidget = BubleMessage(
                message: message,
                sender: sender,
                isMe: thisUser == sender,
                timeStamp: timeStamp.toDate());
            messageWidget.add(messagesWidget);
            print(thisUser);
            print(sender);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              children: messageWidget,
            ),
          );
        });
  }
}

class BubleMessage extends StatelessWidget {
  BubleMessage(
      {required this.message,
      required this.sender,
      required this.isMe,
      required this.timeStamp});
  final DateTime timeStamp;
  final String message;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(timeStamp.toString()),
          Text(
            sender,
            style: TextStyle(fontSize: 13.0, color: Colors.black87),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(29),
                    bottomLeft: Radius.circular(29),
                    bottomRight: Radius.circular(29))
                : BorderRadius.only(
                    topRight: Radius.circular(29),
                    bottomLeft: Radius.circular(29),
                    bottomRight: Radius.circular(29)),
            elevation: 6.0,
            color: isMe ? Colors.blue : Colors.purpleAccent,
            child: Padding(
              padding: EdgeInsets.all(13),
              child: Text(
                message,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
