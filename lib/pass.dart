import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_fast/data.dart';
import 'package:login_fast/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Password extends StatefulWidget {
  final String type;
  final String username;
  Password({Key key, @required this.type, @required this.username}) : super(key: key);
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  bool passwordVisible;
  TextEditingController pass = TextEditingController();
  String token;
  bool authSuccess;
  var authresponse;

  _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString("type");
    prefs.setBool("loggedIn",false);
    prefs.remove("username");
    prefs.remove("type");
    if(type == "Google") {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'],);
      await _googleSignIn.signOut();
    }
    else if(type == "Facebook") {
      FacebookLogin _facebookLogin = FacebookLogin();
      await _facebookLogin.logOut();
    }
    else if(type == "Phone") {
      FirebaseAuth _auth = FirebaseAuth.instance;
      _auth.signOut();
    }
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(
        builder: (context) => SignOptions()
      ),
      ModalRoute.withName('/')
    );
  }

  _login() async {
    final response = await http.post("http://192.168.43.18:8000/token", body: {
      "username": "${widget.username}",
      "password": pass.text,
    });
    authresponse = json.decode(response.body);
    if(authresponse["detail"] != null) {
      setState(() {
        authSuccess = true;
      });
    }
    else {
      token = authresponse["access_token"];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Data(username: "${widget.username}",token: token))
      );
    }
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    authSuccess = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password"),
        backgroundColor: Colors.black,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child : new IconButton(
              icon: new Icon(Icons.exit_to_app),
              onPressed: _logOut
            )
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: pass,
                keyboardType: TextInputType.text,
                obscureText: passwordVisible,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Create Password",
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black) 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black) 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black) 
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    color: Colors.black,
                  )
                ),
              ),
              /*TextField(
                keyboardType: TextInputType.text,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  )
                ),
              ),*/
              SizedBox(height: 50.0),
              RaisedButton(
                child: Text("Confirm"),
                onPressed: () {
                  _login();
                },
                textColor: Colors.white,
                elevation: 2.0,
                color: Colors.black,
              ),
              authSuccess
              ? Container(
                child: Text(authresponse.toString()),
              )
              : Container()
            ],
          ),
        ),
      ),
    );
  }
}