import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class News extends StatelessWidget{

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
          color: Colors.blueGrey,
          padding: EdgeInsets.all(10),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget> [
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(10.0),
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
                    child: Column(
                      children: <Widget> [
                        Image.network('https://kj1bcdn.b-cdn.net/media/41905/famrers.jpg'),
                        Text("Forming new panel is not a solution, says farmer leaders on SC proposal "),
                        InkWell(
                            child: new Text('Read more...',style: TextStyle(color: Colors.blueAccent,),),
                            onTap: () => launch('https://krishijagran.com/news/forming-new-panel-is-not-a-solution-says-farmer-leaders-on-sc-proposal/')
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(15.0),
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
                    child: Column(
                      children: <Widget> [
                        Image.network('https://kj1bcdn.b-cdn.net/media/41893/mamata_2_.jpg'),
                        Text("Good news: West Bengal Government’s New Health Scheme to benefit Farming, Rural Community"),
                        InkWell(
                            child: new Text('Read more...',style: TextStyle(color: Colors.blueAccent,),),
                            onTap: () => launch('https://krishijagran.com/news/good-news-west-bengal-government-s-new-health-scheme-to-benefit-farming-rural-community/')
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(15.0),
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
                    child: Column(
                      children: <Widget> [
                        Image.network('https://kj1bcdn.b-cdn.net/media/41883/road_bloakade.jpg'),
                        Text("Farm Bills 2020: Here’s what the Supreme Court and Centre said about the resolution for Farmer protests"),
                        InkWell(
                            child: new Text('Read more...',style: TextStyle(color: Colors.blueAccent,),),
                            onTap: () => launch('https://krishijagran.com/news/farm-bills-2020-here-s-what-the-supreme-court-and-centre-said-about-the-resolution-for-farmer-protests/')
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(15.0),
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
                    child: Column(
                      children: <Widget> [
                        Image.network('https://kj1bcdn.b-cdn.net/media/41856/ns-bku.jpg'),
                        Text("Bharatiya Kisan Union (Kisan) from UP supports Farm Bills"),
                        InkWell(
                            child: new Text('Read more...',style: TextStyle(color: Colors.blueAccent,),),
                            onTap: () => launch(' https://krishijagran.com/news/bharatiya-kisan-union-kisan-from-up-supports-farm-bills/')
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(15.0),
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
                    child: Column(
                      children: <Widget> [
                        Image.network('https://kj1bcdn.b-cdn.net/media/41853/modii.png'),
                        Text("We are committed to farmer welfare and we will keep assuring the farmers says, PM Modi"),
                        InkWell(
                            child: new Text('Read more...',style: TextStyle(color: Colors.blueAccent,),),
                            onTap: () => launch(' https://krishijagran.com/news/we-are-committed-to-farmer-welfare-and-we-will-keep-assuring-the-farmers-says-pm-modi/')
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}