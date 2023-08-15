import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jchat/Choosing_Screen.dart';
import 'package:jchat/login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});
  static String id = "Splash";

  @override
  State<Splash_Screen> createState() => Splash_ScreenState();
}



class Splash_ScreenState extends State<Splash_Screen> {

  static String KEYLOGIN = "login";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wheretogo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitSpinningLines(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  void wheretogo() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isloggedin = sharedpref.getBool(KEYLOGIN);

    Timer(Duration(seconds: 1), (){
      if(isloggedin != null){
        if(!isloggedin){
          Navigator.pushReplacementNamed(context, login_screen.id);
        }
        else{
          Navigator.pushReplacementNamed(context, Choosing_Screen.id);
        }
      }
      else{
        Navigator.pushReplacementNamed(context, login_screen.id);
      }
    });
  }
}
