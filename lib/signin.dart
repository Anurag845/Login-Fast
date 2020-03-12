import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:login_fast/pass.dart';
import 'package:login_fast/phone.dart';


class SignOptions extends StatefulWidget {
  @override
  _SignOptionsState createState() => _SignOptionsState();
}

class _SignOptionsState extends State<SignOptions> {
  bool isLoggedGoogle = false;
  bool isLoggedFB = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'],);
  FacebookLogin _facebookLogin = FacebookLogin();

  _loginGoogle() async {
    try{
      await _googleSignIn.signIn();
      setState(() {
        isLoggedGoogle = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Password(type:"google",username:_googleSignIn.currentUser.email))
      );
    } 
    catch (err) {
      print(err);
    }
  }

  _loginFB() async {
    final result = await _facebookLogin.logIn(['email']);
    Map userProfile;
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          isLoggedFB = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Password(type:"facebook",username: userProfile["name"],))
        );
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => isLoggedFB = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => isLoggedFB = false );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In Options"),
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
                  _loginFB();
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
          ),
        ),
      ),
    );
  }
}