import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:login_fast/signin.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Data extends StatefulWidget {
  final String username;
  final String token;
  Data({Key key, @required this.username, @required this.token}) : super(key: key);
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  Map user;
  bool fetched;

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

  _getData(String id) async{
    var response = await http.get("http://192.168.43.18:8000/userinfo/"+id, 
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
    user = json.decode(response.body);
    setState(() {
      fetched = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetched = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Data"),
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
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    child: Text("Check A"),
                    onPressed: () {
                      _getData("anuraggujarathi@gmail.com");
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    child: Text("Check B"),
                    onPressed: () {
                      _getData("Anurag Gujarathi");
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    child: Text("Check C"),
                    onPressed: () {
                      _getData("+919422324985");
                    },
                  ),
                )
              ],
            ),
            fetched
            ? Container(
              child: Column(
                children: <Widget>[
                  Text(user.toString()),
                  //Text("Data" + user["data"]),
                ],
              ),
            )
            : Container(),
          ],
        ),
      ),
    );
  }
}