import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import 'dart:ffi';

class Chat extends StatefulWidget {

  final String stringmessage;

  Chat({required this.stringmessage});
  // const Chat({Key? key}) : super(key: key);



static String id = 'Chat';


  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  Future<void> createFirestoreCollection() async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection(stringmessage).doc('dummyDoc').set({});
  }

  late String stringmessage;



  final mesaagecontroller = TextEditingController();

  String message = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;
  late User loggedinUser;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stringmessage = widget.stringmessage;
    createFirestoreCollection();

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                  MaterialSymbols.close,
                color: Colors.black,
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: stringmessage));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Unique Code copied to clipboard"),
                backgroundColor: Color(0xFF0df5e3),
              ),
            );
          },
          child: Text(
              'JChat : $stringmessage',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic
            ),
          ),
        ),
        backgroundColor: Color(0xFFfaf4d0),
      ),
      body: Center(
      child: Container(
      decoration: const BoxDecoration(
      gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xFFf3d245),
        Color(0xFFea7c43),

        // Color(0xFFad2b90),
        // Color(0xFF4e3aad),
        // Colors.white,

      ],
    )
    ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore.collection(stringmessage).orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: SpinKitFadingFour(
                  color: Colors.redAccent,
                ),
              );
            }
            final messages = snapshot.data!.docs;
            List<MessageBubbles> messageBubbles = [];
            // messageBubbles.add(MessageBubbles('JChat', 'Welcome To JChat', false, DateTime.now().toUtc().millisecondsSinceEpoch));
            for (var message in messages) {
              final messageText = message.data()['text'];
              final messageSender = message.data()['sender'];
              final messageTimestamp = message.data()['timestamp'];

              final currentuser = loggedinUser.email;

              final messageWidget = MessageBubbles(messageSender, messageText, currentuser == messageSender, messageTimestamp);
              messageBubbles.add(messageWidget);
            }

            messageBubbles.add(MessageBubbles('JChat', 'Welcome To JChat', false, DateTime.now().toUtc().millisecondsSinceEpoch));

            return Expanded(
              child: ListView(
                reverse: true,
                children: messageBubbles,
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
                          color: Colors.black87,
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
                        _firestore.collection(stringmessage).add({
                            'sender' : loggedinUser.email,
                          'text' : message,
                          'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
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

// class MessageBubbles extends StatelessWidget {
//
//   String sender;
//   String text;
//   bool isMe;
//
//
//   MessageBubbles(@required this.sender, @required this.text, @required this.isMe);
//
//   // get timestamp => null;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$sender',
//             style: TextStyle(
//               color: Colors.black45,
//               fontSize: 12,
//             ),
//           ),
//           Material(
//             elevation: 5,
//             borderRadius: BorderRadius.only(
//               // topLeft: Radius.circular(30),
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//               topRight: isMe? Radius.zero : Radius.circular(30),
//               topLeft: isMe? Radius.circular(30) : Radius.zero,
//
//             ),
//             color: isMe ?  Colors.blue : Colors.teal,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text(
//                 '$text',
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: CupertinoColors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

class MessageBubbles extends StatelessWidget {

  String sender;
  String text;
  bool isMe;
  int timestamp;

  MessageBubbles(@required this.sender, @required this.text, @required this.isMe, @required this.timestamp);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Text copied to clipboard"),
            backgroundColor: Color(0xFF0df5e3),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              '$sender',
              style: TextStyle(
                color: Color(0xff303030),
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
              color: isMe ?  Color(0xFF2b68ef) : Color(0xFFe8e9e9),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$text',
                      style: TextStyle(
                        fontSize: 15,
                        color: isMe ?  Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(timestamp)),
                      style: TextStyle(
                        fontSize: 12,
                        color: isMe ?  Colors.white70 : Color(0xff303030),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
