import 'package:flutter/material.dart';
import 'package:smart_farmer/account.dart';
import 'package:flutter/services.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}

class Home extends StatelessWidget {

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
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu_rounded),
            iconSize: 30,
            color: Colors.white,
            splashColor: Colors.grey,
            splashRadius: 28,
            onPressed: () {
              Navigator.push(context, SlideRightRoute(page: Account()));
            },
          ),
          title: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF218868),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          color: Colors.white,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget> [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                          ),],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                      width: double.infinity,
                      child: Row(
                        children: <Widget> [
                          IconButton(
                            icon: Icon(Icons.wb_sunny_rounded),
                            iconSize: 60,
                            color: Colors.orange,
                            onPressed: () {},
                          ),
                          SizedBox(width: 40),
                          Flexible(
                            child: Text(
                              'Weather',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/weather');
                    },
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                            ),],
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                      width: double.infinity,
                      child: Row(
                        children: <Widget> [
                          IconButton(
                            icon: Icon(Icons.camera_alt_rounded ),
                            iconSize: 60,
                            color: Colors.brown,
                            onPressed: () {},
                          ),
                          SizedBox(width: 40),
                          Flexible(
                            child: Text(
                              'Crop Scanner',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/scanner');
                    },
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                            ),],
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                      width: double.infinity,
                      child: Row(
                        children: <Widget> [
                          IconButton(
                            icon: Icon(Icons.description_outlined ),
                            iconSize: 60,
                            color: Colors.black87,
                            onPressed: () {},
                          ),
                          SizedBox(width: 40),
                          Flexible(
                            child: Text(
                              'News',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/news');
                    },
                  ),

                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}