import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jchat/Existing_Chats.dart';
import 'package:jchat/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GroupCode.dart';
import 'Splash_Screen.dart';

class Choosing_Screen extends StatefulWidget {
  const Choosing_Screen({super.key});
  static String id = 'Choose';

  @override
  State<Choosing_Screen> createState() => _Choosing_ScreenState();
}

class _Choosing_ScreenState extends State<Choosing_Screen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'What to do next?'
        ),
        backgroundColor: const Color(0xFF39304d),
        actions: [IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            var sharedpre = await SharedPreferences.getInstance();
            sharedpre.setBool(Splash_ScreenState.KEYLOGIN, false);
            Navigator.pushNamed(context, login_screen.id);
          },
          iconSize: 30,
        ),]

      ),
      backgroundColor: Color(0xFF201b30),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Flexible(
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
            FadeTransition(
              opacity: fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Material(
                  color: Color(0xFF0df5e3),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Code_Group.id);
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Join or Create New Chat Group',
                      style: TextStyle(
                        color: Color(0xFF1e1a31),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            FadeTransition(
              opacity: fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Material(
                  color: Color(0xFF0df5e3),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Existing_Chats.id);
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'See Existing Chat Groups',
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
      ),
    );
  }
}
