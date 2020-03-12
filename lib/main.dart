import 'package:flutter/material.dart';
import 'package:login_fast/pass.dart';
import 'package:login_fast/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

isLogged(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool("loggedIn");
  if(!loggedIn) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignOptions(),
        )
      );
    });
  }
  else {
    String type = prefs.getString("type");
    String username = prefs.getString("username");
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Password(type: type, username: username,),
        ),
      );
    });
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Logo(),
    );
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    isLogged(context);
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}