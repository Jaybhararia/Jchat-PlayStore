import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'chat_screen.dart';
import 'registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login_screen extends StatefulWidget {

  static String id = 'welcomescreen';
  // const login_screen({Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> with SingleTickerProviderStateMixin {

  bool showspinner = false;

  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;

  late AnimationController controller;
  late Animation animation;
  late Animation animation1;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
        vsync: this,
      // upperBound: 100,
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    animation1 = ColorTween(begin :Colors.black12, end : Color(0xFF201b30)).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {

      });
      print(animation.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation1.value,
      body: ModalProgressHUD(

        progressIndicator: SpinKitFadingFour(
          color: Colors.redAccent,
        ),

        inAsyncCall: showspinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: (animation.value) * 200,
                    child: Image.asset('images/logo_without_background.png'),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),


              Row(
                children: [
                  Expanded(
                    flex: 1,
                      child: Icon(MaterialSymbols.mail)
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(

                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        // cursorColor: const Color(0xFF39304d),
                        onChanged: (value){
                            email = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          focusColor: const Color(0xFF39304d),
                          hintText: 'Enter Your Email',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF201b31),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: const Color(0xFF39304d),
                              width: 1,
                            )
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Icon(MaterialSymbols.password)
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(

                      child: TextField(
                        obscureText: true,
                        // cursorColor: const Color(0xFF39304d),
                        onChanged: (value){
                            password = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                            focusColor: const Color(0xFF39304d),
                            hintText: 'Enter Your Password',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF201b31),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: const Color(0xFF39304d),
                                  width: 1,
                                )
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Expanded(
                        child: Material(
                            color: Color(0xFF0df5e3),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          elevation: 5,
                          child: MaterialButton(
                              onPressed: () async {
                                try{
                                  setState(() {
                                    showspinner = true;
                                  });
                                  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                                  print(user.credential);
                              setState(() {
                                    showspinner = false;
                                  });

                                  if(user != null){
                                    Navigator.pushNamed(context, Chat.id);
                                  }

                                }
                                catch(e){
                                  print(e);
                                }
                              },

                            minWidth: 200.0,
                            height: 42.0,
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: Color(0xFF1e1a31),
                              ),
                            ),
                          ),
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Expanded(
                      child: Material(
                        color: Color(0xFF0df5e3),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5,
                        child: MaterialButton(
                          onPressed: (){
                              Navigator.pushNamed(context, Register.id);
                          },

                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'Don\'t have an account? Sign Up',
                            style: TextStyle(
                              color: Color(0xFF1e1a31),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
