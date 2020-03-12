import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_fast/pass.dart';

class Phone extends StatefulWidget {
  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  String phoneNo;
  String smsCode;
  String verificationId;
 
  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
 
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed in');
      });
    };
 
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential credential) {
      print('verified');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Password(type: "phone",username: phoneNo,)),
      );
    };
 
    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };
 
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: veriFailed
    );
  }
 
  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('Enter sms Code'),
          content: TextField(
            onChanged: (value) {
              this.smsCode = value;
            },
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            new FlatButton(
              child: Text('Done'),
              onPressed: () {
                FirebaseAuth.instance.currentUser().then((user) {
                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Password(type: "phone",username: phoneNo,)),
                    );
                  } 
                  else {
                    Navigator.of(context).pop();
                    signIn();
                  }
                });
              },
            )
          ],
        );
      }
    );
  }
 
  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.signInWithCredential(credential).then((user) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Password(type:"phone",username: phoneNo,)),
      );
    }).catchError((e) {
      print(e);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('PhoneAuth'),
        backgroundColor: Colors.black,
      ),
      body: new Center(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Enter Phone number',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  this.phoneNo = value;
                },
              ),
              SizedBox(height: 50.0),
              RaisedButton(
                onPressed: verifyPhone,
                child: Text('Verify'),
                textColor: Colors.white,
                elevation: 2.0,
                color: Colors.black,
              ),
            ],
          )
        ),
      ),
    );
  }
}