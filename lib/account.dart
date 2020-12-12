import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Account extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Ubuntu',
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu_rounded),
            iconSize: 30,
            color: Colors.white,
            splashColor: Colors.grey,
            splashRadius: 25,
            onPressed: () => {
              Navigator.pop(context)
            },
          ),
          title: Text(
            'Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF218868),
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text('Account'),
          ),
        ),
      ),
    );
  }
}