import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jchat/Choosing_Screen.dart';
import 'package:jchat/Existing_Chats.dart';
import 'package:jchat/Splash_Screen.dart';
import 'ForgotPasswordScreen.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'chat_screen.dart';
import 'verification_screen.dart';
import 'package:jchat/GroupCode.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      // home: Chat(),
      initialRoute: Splash_Screen.id,
      routes: {
        Splash_Screen.id : (context) => Splash_Screen(),
        Register.id :(context) => Register(),
        login_screen.id : (context) => login_screen(),
        Verification.id : (context) => Verification(),
        ForgotPassword.id : (context) => ForgotPassword(),
        Code_Group.id : (context) => Code_Group(),
        Choosing_Screen.id : (context) => Choosing_Screen(),
        Existing_Chats.id : (context) => Existing_Chats(),
      },
    );
  }
}
