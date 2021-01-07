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
List<Color> temperatureColors = [Colors.orangeAccent,Colors.orange,Colors.deepOrangeAccent,Colors.deepOrange,Colors.red];
List<Color> windColors = [Colors.blueGrey.shade100,Colors.blueGrey.shade200,Colors.blueGrey.shade300,Colors.blueGrey.shade400,Colors.blueGrey.shade500];
List<Color> waterColors = [Colors.blue.shade100,Colors.blue.shade200,Colors.blue.shade300,Colors.blue.shade400,Colors.blue.shade500];


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
  var rule = false;
  Widget descriptionW = Divider(
    color: Colors.black12,
    height: 30,
    thickness: 1,
    indent: 0,
    endIndent: 0,
  );

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
      width: MediaQuery.of(context).size.width*0.095,
    )).toList());
  }

  List<Container> waterBar(int count) {
    return(List.generate(count, (i) => Container(
      margin: EdgeInsets.fromLTRB( 2, 0, 0, 0),
      color: waterColors[i],
      height: 20,
      width: MediaQuery.of(context).size.width*0.1,
    )).toList());
  }

  List<Container> windBar(int count) {
    return(List.generate(count, (i) => Container(
      margin: EdgeInsets.fromLTRB( 2, 0, 0, 0),
      color: windColors[i],
      height: 20,
      width: MediaQuery.of(context).size.width*0.1,
    )).toList());
  }

  getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      this.latitudeData = '${geoposition.latitude}';
      this.longitudeData = '${geoposition.longitude}';
    });
  }

   descriptionWidget(var value) {
    if(value == false){
      setState(() {
        this.descriptionW = Divider(
          color: Colors.black12,
          height: 30,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        );
      });
    }
    else{
      setState(() {
        this.descriptionW = Text("");
      });
    }
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
          child: this.status != null ?
          SingleChildScrollView(
            padding: EdgeInsets.all(5.0),
            child: this.status?
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    Flexible(
                      child: Row(
                        children: <Widget> [
                          SizedBox(width: 15,),
                          Flexible(
                            child: Text(widget.cropName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: widget.image == null ?
                          Row(
                            children: <Widget> [
                              FaIcon(FontAwesomeIcons.seedling),
                              SizedBox(width: 20,),
                            ],
                          )
                          : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(widget.image,),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                ExpansionTile(
                  trailing: FaIcon(FontAwesomeIcons.infoCircle,color: Colors.black45),
                  title: descriptionW,
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Text(
                      this.description,
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                  onExpansionChanged: descriptionWidget,
                ),
                SizedBox(height: 10,),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, left: 5.0, right: 0, bottom: 5.0),
                    child: ExpansionTile(
                      trailing: FaIcon(FontAwesomeIcons.infoCircle,color: Colors.black45),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                          Image(image: AssetImage('assets/WateringCan.png'),width: 50,height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: waterBar((this.waterRequirement+this.temperatureValue)~/2),
                          ),
                        ],
                      ),
                      children: <Widget>[
                        Row(
                          children: <Widget> [
                            Text("Current weather: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              weather != null ? weather : "Loading",
                              style: TextStyle(
                                color: Colors.black,
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
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, left: 5.0, right: 0, bottom: 5.0),
                    child: ExpansionTile(
                      trailing: FaIcon(FontAwesomeIcons.infoCircle,color: Colors.black45),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                          Image(image: AssetImage('assets/Thermometer.png'),width: 50,height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: temperatureBar(this.temperatureValue),
                          ),
                        ],
                      ),
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Row(
                          children: <Widget> [
                            Text("Current temperature: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              temperature != null ? temperature.toStringAsFixed(0) + "\u00B0c" : "Loading",
                              style: TextStyle(
                                color: Colors.black,
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
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, left: 5.0, right: 0, bottom: 5.0),
                    child: ExpansionTile(
                      trailing: FaIcon(FontAwesomeIcons.infoCircle,color: Colors.black45),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                          Image(image: AssetImage('assets/WindSpeed.png'),width: 50,height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: windBar(this.windValue),
                          ),
                        ],
                      ),
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Row(
                          children: <Widget> [
                            Text("Current wind speed: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              windSpeed != null ? windSpeed.toStringAsFixed(1) + " km/h" : "Loading",
                              style: TextStyle(
                                color: Colors.black,
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
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
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
                ),
          ):
          Center(
            child: Loading(
                indicator: BallPulseIndicator(),
                size: 50.0,
                color: Colors.green.shade600),
          ),
        ),
      ),
    );
  }
}