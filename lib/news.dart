import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading/loading.dart';




class News extends StatefulWidget{

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {

  var news;
  var connection = false;


  getNews() async {
    http.Response response = await http.post("http://smart-farmer-3.herokuapp.com/news");
    setState(() {
      this.news = json.decode(response.body);
      this.connection = true;
    });
  }

  List<Container> generateNewsList() {
    return (List.generate(news.length, (i) =>
        Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            decoration: BoxDecoration(
              color: Colors.lightGreen.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: <Widget>[
                Image.network(
                    news[i.toString()]["image"]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      news[i.toString()]["title"]),
                ),
                InkWell(
                    child: new Text('Read more...',
                      style: TextStyle(color: Colors.lightBlueAccent,),),
                    onTap: () =>
                        launch(
                            news[i.toString()]["link"])
                ),
              ],
            )
        )).toList());
  }

  @override
  void initState(){
    super.initState();
    this.getNews();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Ubuntu',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'News',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 30,
            color: Colors.white,
            splashColor: Colors.grey,
            splashRadius: 25,
            onPressed: () => {
              Navigator.pop(context)
            },
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF218868),
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Center(
            child: this.connection == true ?
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: this.generateNewsList(),
              ),
            ):
            Loading(
                indicator: BallPulseIndicator(),
                size: 50.0,
                color: Colors.green.shade600)
          ),
        ),
      ),
    );
  }
}