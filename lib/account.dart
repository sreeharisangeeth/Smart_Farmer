import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_configuration/global_configuration.dart';

class Account extends StatefulWidget{

  @override
  _AccountState createState() => _AccountState();
}

getValue() async{
  await GlobalConfiguration().loadFromAsset("user");
}

class _AccountState extends State<Account> {

  String user;
  String email;

  @override
  void initState() {
    super.initState();
    getValue();
    this.user = GlobalConfiguration().getValue("user");
    this.email = GlobalConfiguration().getValue("email");
  }

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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey,
                  blurRadius: 4,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget> [
                  Container(
                    child: FaIcon(FontAwesomeIcons.user,color: Colors.black87,size: 70,),
                  ),
                    Text(this.user,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                    SizedBox(height: 30,),
                    Text("Email: ${this.email}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 60,),
                    Container(
                      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                      child: RaisedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FaIcon(FontAwesomeIcons.signOutAlt,color: Colors.white,),
                            SizedBox(width: 10,),
                            Text("Logout",
                              style: TextStyle(color: Colors.white,fontSize: 15),),
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        onPressed: () {
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}