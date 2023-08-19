import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jchat/Existing_Chats/Chat_Tile.dart';
import 'package:jchat/Screens/Choosing_Screen.dart';
import 'package:jchat/Screens/Name_New_Group.dart';
import 'package:jchat/Screens/Splash_Screen.dart';
import 'Screens/ForgotPasswordScreen.dart';
import 'Screens/login_screen.dart';
import 'Screens/registration_screen.dart';
import 'Screens/chat_screen.dart';
import 'Screens/verification_screen.dart';
import 'package:jchat/Screens/GroupCode.dart';

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
        New_Code.id : (context) => New_Code(),
        Chat_Tile.id : (context) => Chat_Tile(),
      },
    );
  }
}
