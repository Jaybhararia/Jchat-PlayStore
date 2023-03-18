import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  // const Chat({Key? key}) : super(key: key);
static String id = 'Chat';
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final mesaagecontroller = TextEditingController();

  String message = '';

  final _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;
  late User loggedinUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    getCurrentUser();
  }

  void getCurrentUser() async{
    try{
      final user = await _auth.currentUser;
      if(user != null){
        loggedinUser = user;
        print(loggedinUser.email);
      }
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
              icon: Icon(MaterialSymbols.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('JChat'),
        backgroundColor: Color(0xFF38314c),
      ),
      body: Center(
      child: Container(
      decoration: BoxDecoration(
      gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xFF9A9CEA),
        Colors.redAccent.shade200,

      ],
    )
    ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore.collection('messages').orderBy('date').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SpinKitFadingFour(
                        color: Colors.redAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data!.docs.reversed;
                  List<MessageBubbles> messageBubbles = [];
                  for (var message in messages) {
                    final messageText = message.data()['text'];
                    final messageSender = message.data()['sender'];


                    final currentuser = loggedinUser.email;


                    final messageWidget = MessageBubbles(messageSender, messageText, currentuser == messageSender);
                    messageBubbles.add(messageWidget);

                    // final currentUser = loggedinUser.email;
                  }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageBubbles
                    ),
                  );
                }
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Expanded(
                      child: TextField(
                        controller: mesaagecontroller,
                        style: TextStyle(
                          color: Colors.yellow,
                        ),
                        onChanged: (value) {
                          message = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        mesaagecontroller.clear();
                        _firestore.collection('messages').add({
                            'sender' : loggedinUser.email,
                          'text' : message,
                          'date': DateTime.now().toIso8601String().toString(),
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
          ),
        ),
      ),
    ),);
  }
}

class MessageBubbles extends StatelessWidget {

  String sender;
  String text;
  bool isMe;


  MessageBubbles(@required this.sender, @required this.text, @required this.isMe);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12,
            ),
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.only(
              // topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topRight: isMe? Radius.zero : Radius.circular(30),
              topLeft: isMe? Radius.circular(30) : Radius.zero,

            ),
            color: isMe ?  Colors.blue : Colors.teal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

