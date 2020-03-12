import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  _getData(String id) async{
    var response = await http.get("http://192.168.43.18:8000/userinfo/"+id, headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
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