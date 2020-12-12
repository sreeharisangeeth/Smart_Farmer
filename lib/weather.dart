import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {


  String latitudeData = "";
  String longitudeData = "";
  String apiKey = "";
  var location;
  var climate;
  var description;
  var temperature;
  var humidity;
  var windSpeed;
  var icon;

  Future getWeather() async{
    await DotEnv().load('.env');
    this.apiKey = DotEnv().env['weatherApiKey'];
    await getCurrentLocation();
    http.Response response = await http.get("http://api.openweathermap.org/data/2.5/weather?lat=$latitudeData&lon=$longitudeData&appid=$apiKey");
    var results = jsonDecode(response.body);
    setState(() {
      this.location = results['name'];
      this.climate = results['weather'][0]['main'];
      this.description = results['weather'][0]['description'];
      this.humidity = results['main']['humidity'];
      this.temperature = results['main']['temp'] - 273.15;
      this.windSpeed =  results['wind']['speed'] * 3.6;
      this.icon = results['weather'][0]['icon'];
    });
  }
  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  getCurrentLocation() async {
    final geoposition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

    setState(() {
      this.latitudeData = '${geoposition.latitude}';
      this.longitudeData = '${geoposition.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Ubuntu',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Weather',
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
            onPressed: () =>
            {
              Navigator.pop(context)
            },
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF218868),
        ),
        body: Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(15.0),
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
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
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.38,
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              location != null ? "Currently in " + location.toString() : "Loading",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                climate != null ? climate.toString() : "Loading",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10,),
                              location != null ? Image.network(
                                'http://openweathermap.org/img/wn/$icon@2x.png',
                                width: 60.0,
                                height: 60.0,
                              ) :
                              Loading(
                                  indicator: BallPulseIndicator(),
                                  size: 50.0,
                                  color: Colors.blueAccent),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              description != null ? description.toString() : "Loading",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.41,
                  padding: EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    FaIcon(FontAwesomeIcons.thermometerHalf),
                                    SizedBox(width: 10.0,),
                                    Text("Temperature",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                temperature != null ? temperature.toStringAsFixed(0) + "\u00B0c" : "Loading",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    FaIcon(FontAwesomeIcons.tint),
                                    SizedBox(width: 10.0,),
                                    Text("Humidity",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                humidity != null ? humidity.toStringAsFixed(0) + "%" : "Loading",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    FaIcon(FontAwesomeIcons.wind),
                                    SizedBox(width: 10.0,),
                                    Text("Wind Speed",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                windSpeed != null ? windSpeed.toStringAsFixed(1) + " km/h" : "Loading",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}