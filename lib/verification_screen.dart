import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'login_screen.dart';

class Verification extends StatefulWidget {

  static String id = 'verify';

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {

  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkemailverified();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFF201b31),
      appBar: AppBar(
        // backgroundColor: Colors.black,
        title: Text(
          'Verify Your Email Address'
        ),


      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Please Open your Email and verify your account to start using JChat',
              textAlign: TextAlign.center,
        // backgroundColor: Color(0xFF38314c),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          SpinKitFadingFour(
            color: Colors.redAccent,
          )
        ],
      ),
    );
  }

  Future<void> checkemailverified() async{
    user = auth.currentUser!;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      Navigator.pushNamed(context, login_screen.id);
    }
  }
}

