import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Color> temperatureColors = [Colors.orangeAccent,Colors.orange,Colors.deepOrangeAccent,Colors.deepOrange,Colors.red];

class Suggestion extends StatefulWidget {

  final String cropName;
  final File image;
  Suggestion({Key key, @required this.cropName, @required this.image}) : super(key: key);

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {

  String latitudeData = "";
  String longitudeData = "";
  String apiKey = "";
  var weather;
  var description;
  var temperature;
  var windSpeed;
  var status;
  var weatherDescription;
  var waterRequirement;
  var temperatureDescription;
  var temperatureValue;
  var windDescription;
  var windValue;
  var message;

  Future getSuggestions() async{
    http.Response response = await http.post("https://smart-farmer-3.herokuapp.com/suggestions?crop=${widget.cropName}&temperature=${this.temperature}&wind=${this.windSpeed}&weather=${this.weather}");
    if(response.statusCode == 200){
      this.status = true ;
      var result = json.decode(response.body);
      if(result["status"] == 404){
        setState(() {
          this.status = false;
          this.message = result["message"];
        });
      }
      else{
        setState(() {
          this.status = true;
          this.description = result["description"];
          this.weatherDescription = result["weather_description"];
          this.waterRequirement = result["water_requirement"];
          this.temperatureDescription = result["temperature_description"];
          this.temperatureValue = result["temperature_value"];
          this. windDescription = result["wind_description"];
          this.windValue = result["wind_value"];
          print(this.temperatureValue);
        });
      }
    }
  }

  Future getWeather() async{
    await DotEnv().load('.env');
    this.apiKey = DotEnv().env['weatherApiKey'];
    await getCurrentLocation();
    http.Response response = await http.get("http://api.openweathermap.org/data/2.5/weather?lat=$latitudeData&lon=$longitudeData&appid=$apiKey");
    var results = jsonDecode(response.body);
    setState(() {
      this.weather = results['weather'][0]['main'];
      this.temperature = results['main']['temp'] - 273.15;
      this.windSpeed =  results['wind']['speed'] * 3.6;
    });
    this.getSuggestions();
  }
  @override
  void initState(){
    super.initState();
    this.getWeather();
  }

  List<Container> temperatureBar(int count) {
    return(List.generate(count, (i) => Container(
      margin: EdgeInsets.fromLTRB( 2, 0, 0, 0),
      color: temperatureColors[i],
      height: 20,
      width: MediaQuery.of(context).size.width*0.16,
    )).toList());
  }

  List<Container> waterBar(int count) {
    return(List.generate(count, (i) => Container(
      margin: EdgeInsets.fromLTRB( 0, 0, MediaQuery.of(context).size.width*0.03, 0),
      child: FaIcon(
        FontAwesomeIcons.tint,
        color: Colors.blue,
      ),
    )).toList());
  }

  List<Container> windBar(int count) {
    return(List.generate(count, (i) => Container(
      margin: EdgeInsets.fromLTRB( 0, 0, MediaQuery.of(context).size.width*0.06, 0),
      child: FaIcon(
        FontAwesomeIcons.wind,
        color: Colors.blueGrey,
        size: 30,
      ),
    )).toList());
  }

  getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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
            padding: EdgeInsets.all(5.0),
            child: this.status != null ? this.status?
            Column(
              children: <Widget> [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    Text(widget.cropName ?? 'deafault',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: widget.image == null ? Text("Image") : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(widget.image,),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text(
                  this.description,
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget> [
                    FaIcon(FontAwesomeIcons.shower,color: Colors.blueGrey,),
                    SizedBox(width: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: waterBar(this.waterRequirement*2),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget> [
                    Text("Current weather: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      weather != null ? weather : "Loading",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Text(
                  weatherDescription,
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget> [
                    FaIcon(FontAwesomeIcons.thermometerHalf,color: Colors.deepOrange,),
                    SizedBox(width: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: temperatureBar(this.temperatureValue),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget> [
                    Text("Current temperature: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
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
                SizedBox(height: 10.0,),
                Text(
                  temperatureDescription,
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget> [
                    Text("Wind",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: windBar(this.windValue),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget> [
                    Text("Current wind speed: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
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
                SizedBox(height: 10.0,),
                Text(
                  windDescription,
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              ],
            ):
                Column(
                  children: <Widget> [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget> [
                        Text(widget.cropName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: widget.image == null ? Text("Image") : CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(widget.image,),
                          ),
                        ),
                      ],
                    ),
                    Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget> [
                            SizedBox(height: 100,),
                            FaIcon(FontAwesomeIcons.timesCircle,color: Colors.red,size: 50,),
                            SizedBox(height: 10,),
                            Text(this.message,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            ),
                          ],
                        ),
                    ),
                  ],
                )
            :
            Center(
              child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 50.0,
                  color: Colors.blueAccent),
            ),
          ),
        ),
      ),
    );
  }
}