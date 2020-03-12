import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_fast/data.dart';

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