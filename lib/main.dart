import 'package:flutter/material.dart';
import 'package:login_fast/signin.dart';

void main() => runApp(MyApp());

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
      home: SignOptions(),
    );
  }
  

  /*GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'],);

  _loginGoogle() async {
    try{
      await _googleSignIn.signIn();
      setState(() {
        
      });
    } 
    catch (err) {
      print(err);
    }
  }

  _logout() {
    _googleSignIn.signOut();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  child: Text("Login with Google"),
                  onPressed: () {
                    _loginGoogle();
                  },
                ),
                OutlineButton(
                  child: Text("Login with Facebook"),
                  onPressed: () {
                    
                  },
                ),
                OutlineButton(
                  child: Text("Login with Phone"),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) => Phone())
                    );
                  },
                ),
              ],
            )
          )
        ),
      ),
    );
  }*/
}