import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'chat_screen.dart';
import 'verification_screen.dart';
import 'package:jchat/chat_screen.dart';

class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  static String id = 'register';
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  void alert(Object e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey,
            title: Text('Problem Signing in...'),
            content: Text(e.toString()),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, Register.id);
                },
                child: Text(
                  'Go back to login screen',
                ),
              )
            ],
          );
        });
  }

  bool showspinner = false;

  String email = '';
  String password = '';
  final _auth = FirebaseAuth.instance;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF201b30),
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
                    height: 200.0,
                    child: FadedScaleAnimation(child: Image.asset('images/image_logo.png')),
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
                        // cursorColor: const Color(0xFF39304d),
                        // textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        // keyboardAppearance: ,
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

              SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Material(
                  color: Color(0xFF0df5e3),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5,
                  child: MaterialButton(
                    onPressed: () async {
                      setState(() {
                        showspinner = true;
                      });
                      try{
                        final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                        setState(() {
                          showspinner = false;
                        });
                        if(newUser != null){
                          Navigator.pushNamed(context, Verification.id);

                        }
                      }
                      catch(e){
                        showspinner = false;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar
                          (backgroundColor: Color(0xFF0df5e3),
                          content: Text(e.toString()),
                        ));
                      }
                    },

                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Color(0xFF1e1a31),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );;
  }
}
