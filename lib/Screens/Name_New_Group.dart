import 'dart:math';

import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jchat/Existing_Chats/Existing_Chat_List.dart';
import 'package:jchat/Existing_Chats/Group_Details.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';

import 'chat_screen.dart';

class New_Code extends StatefulWidget {

  static String id = 'New_Code';
  const New_Code({Key? key}) : super(key: key);

  @override
  State<New_Code> createState() => _New_CodeState();
}

class _New_CodeState extends State<New_Code> {

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
  String name = '';

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
        backgroundColor: const Color(0xFF39304d),
        title: Text('Create a New Group'),
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
                    flex: 1, child: Icon(Icons.abc
                  ),),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                      child: TextField(
                        // cursorColor: const Color(0xFF39304d),
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'Group Name',
                            focusColor: const Color(0xFF39304d),
                            hintText: 'Enter The Name of New Group',
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
                    onPressed: () {
                      String v4 = generateRandomString(6);
                      //TODO : here i have to add this string and group in the chat tile
                      Group_Details newGroup = Group_Details(Group_Code: v4, Group_Description: name);
                      Existing_Chat_List().addGroup(newGroup);
                      Existing_Chat_List().saveChatGroups();

                      setState(() {
                        // Update the UI if necessary
                      });
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
                      'Create a New Group',
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

