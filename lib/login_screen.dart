import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jchat/registration_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'ForgotPasswordScreen.dart';
import 'GroupCode.dart';

class login_screen extends StatefulWidget {
  static String id = 'welcomescreen';

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen>
    with SingleTickerProviderStateMixin {
  bool obscure = true;
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
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    animation1 =
        ColorTween(begin: Colors.black12, end: Color(0xFF201b30)).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      },
    );
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
                  const Expanded(flex: 1, child: Icon(MaterialSymbols.mail)),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
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
                            ),
                          ),
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
                  Expanded(flex: 1, child: Icon(MaterialSymbols.password)),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextField(
                              obscureText: obscure,
                              onChanged: (value) {
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
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF0df5e3),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ForgotPassword.id);
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Material(
                      color: Color(0xFF0df5e3),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      elevation: 5,
                      child: MaterialButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              showspinner = true;
                            });
                            final user = await _auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            print(user.credential);
                            setState(() {
                              showspinner = false;
                            });

                            if (user != null) {
                              Navigator.pushNamed(context, Code_Group.id);
                            }
                          } catch (e) {
                            alert(e);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Register.id);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF0df5e3),
                          ),
                        ),
                      ),
                    ],
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
