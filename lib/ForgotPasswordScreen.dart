import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'login_screen.dart';
// import 'package:material_color_utilities/utils';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  static String id = 'forgotpassword';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  
  final _auth = FirebaseAuth.instance;

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
                  Navigator.pushNamed(context, login_screen.id);
                },
                child: Text(
                  'Go back to login screen',
                ),
              )
            ],
          );
        });
  }

  String email = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF201b31),
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Column(
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
            children: [
              Expanded(flex: 1, child: Icon(MaterialSymbols.mail)),
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    // cursorColor: const Color(0xFF39304d),
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Email',
                        focusColor: const Color(0xFF39304d),
                        hintText: 'Enter Your Email',
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
            child: Expanded(
              child: Material(
                color: Color(0xFF0df5e3),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5,
                child: MaterialButton(
                  onPressed: () {
                    _auth.sendPasswordResetEmail(email: email).then((value) =>
                    {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar
                      (
                      backgroundColor: Color(0xFF0df5e3),
                    content: Text("Password Reset Link Has been sent"),
                      // animation: ,
                      duration: Duration(seconds: 3),
                      // backgroundColor: Colors.deepOrangeAccent,
                      // shape: ShapeBorder(
                      //
                      // ),
                    ))
                    }).onError((error, stackTrace) =>
                        {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar
                      (backgroundColor: Color(0xFF0df5e3),
                    content: Text(error.toString()),
                    ))
                        }
                    );
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Send Reset Password Link',
                    style: TextStyle(
                      color: Color(0xFF1e1a31),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
