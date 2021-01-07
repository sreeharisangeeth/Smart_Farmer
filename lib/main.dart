import 'package:flutter/material.dart';
import 'package:smart_farmer/home.dart';
import 'package:smart_farmer/sign_up.dart';
import 'package:smart_farmer/index.dart';
import 'package:smart_farmer/weather.dart';
import 'package:smart_farmer/scanner.dart';
import 'package:smart_farmer/news.dart';
import 'package:smart_farmer/account.dart';
import 'package:smart_farmer/startup.dart';

void main() async{
  runApp(
    MaterialApp(
      initialRoute: '/startup',
      routes: {
        '/startup': (context) => Startup(),
        '/index': (context) => Index(),
        '/sign_up': (context) => SignUp(),
        '/home': (context) => Home(),
        '/weather':(context) => Weather(),
        '/scanner':(context) => Scanner(),
        '/news':(context) => News(),
        '/account':(context) => Account(),
      },
    ),
  );
}