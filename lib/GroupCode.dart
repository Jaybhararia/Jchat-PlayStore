import 'dart:math';

import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';

import 'chat_screen.dart';

class Code_Group extends StatefulWidget {

  static String id = 'codegroup';
  const Code_Group({Key? key}) : super(key: key);

  @override
  State<Code_Group> createState() => _Code_GroupState();
}

class _Code_GroupState extends State<Code_Group> {

  // void alert() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.blueGrey,
  //           title: Text('Problem Signing in...'),
  //           content: Text('Code Value Does not Exist'),
  //           actions: [
  //             MaterialButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Code_Group.id);
  //               },
  //               child: Text(
  //                 'Re-Enter Code',
  //               ),
  //             )
  //           ],
  //         );
  //       });
  // }

  String code = '';

  bool showspinner = false;

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF201b31),
      appBar: AppBar(
        title: Text('Join the Group Chat'),
      ),
      body: ModalProgressHUD(
        progressIndicator: SpinKitFadingFour(
          color: Colors.redAccent,
        ),
        inAsyncCall: showspinner,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200,
                    child: FadedScaleAnimation(child: Image.asset('images/logo_without_background.png')),
                  ),
                ),
              ),
              // Text(
              //   'Enter your Email ID',
              //   style: TextStyle(
              //     fontSize: 20,
              //   ),
              // ),
              // SizedBox(
              //   height: 50,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1, child: Icon(Icons.attachment_outlined
                  ),),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                      child: TextField(
                        // cursorColor: const Color(0xFF39304d),
                        onChanged: (value) {
                          code = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'Unique Code',
                            focusColor: const Color(0xFF39304d),
                            hintText: 'Enter The Unique Code',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF39304d),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: const Color(0xFF39304d),
                                  width: 1,
                                ))),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Material(
                  color: Color(0xFF0df5e3),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5,
                  child: MaterialButton(
                    onPressed: () async {
                      setState(() {
                        showspinner = true;
                      });
                      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                      final CollectionReference _collectionRef = _firestore.collection(code!);

                      bool doesCollectionExist = false;
                      await _collectionRef.limit(1).get().then((value) {
                        doesCollectionExist = value.docs.isNotEmpty;
                      });
                      setState(() {
                        showspinner = false;
                      });

                      if (doesCollectionExist) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chat(stringmessage: code),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar
                          (backgroundColor: Color(0xFF0df5e3),
                          content: Text('Code Value Does Not Exist'),
                        ));
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Verify Code',
                      style: TextStyle(
                        color: Color(0xFF1e1a31),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Material(
                  color: Color(0xFF0df5e3),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5,
                  child: MaterialButton(
                    onPressed: () {
                      String v4 = generateRandomString(6);
                      // String v4 = uuid.v4 as String;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(stringmessage: v4),
                        ),
                      );
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Create a new Code',
                      style: TextStyle(
                        color: Color(0xFF1e1a31),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

