import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:smart_farmer/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

class Startup extends StatefulWidget{

  @override
  _StartupState createState() => _StartupState();
}

class _StartupState extends State<Startup> {

  var status = "disconnected";

  startServer() async{
    http.Response response = await http.get("https://smart-farmer-3.herokuapp.com/start");
    setState(() {
      this.status = response.body;
    });
    if(this.status == "connected"){
      Timer(Duration(seconds: 1),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) =>
                  Index()
              )
          )
      );
    }
  }

  @override
  void initState() {
    super.initState();
    startServer();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Ubuntu',
      ),
      home: Scaffold(
          body: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Image(image: AssetImage('assets/Logo.png'),),
                  Loading(
                      indicator: BallPulseIndicator(),
                      size: 50.0,
                      color: Colors.green.shade600),
                ],
              )
            ),
          ),
    )
    );
  }
}