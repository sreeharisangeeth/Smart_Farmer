import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_farmer/suggestion.dart';
import 'package:dio/dio.dart';




class Scanner extends StatefulWidget{
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  File _image;
  final _picker = ImagePicker();
  String cropName = "";
  String cropAlt="Select an image to start";

  uploadImage() async{
    String fileName = _image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image":
      await MultipartFile.fromFile(_image.path, filename:fileName),
    });
    var response = await Dio().post("https://smart-farmer-3.herokuapp.com/identify", data: formData);
    setState(() {
      this.cropName = response.data;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Suggestion(cropName: this.cropName,image: this._image,),
        ));
  }

  Future captureImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          this._image = File(pickedFile.path);
        });
      }
      else {
        setState(() {
          cropAlt = "No Image Selected";
        });
      }
    });
  }

  Future selectImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          this._image = File(pickedFile.path);
        });
      }
      else {
        Navigator.pop(context);
      }
    });
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
            'Crop Scanner',
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
          padding: EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget> [
                    _image == null ? Text(cropAlt) : ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.file(_image,),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: captureImage,
                          child: Row(
                            children: <Widget>[
                              FaIcon(FontAwesomeIcons.camera,color: Colors.white,),
                              SizedBox(width: 10,),
                              Text("Capture",
                                style: TextStyle(color: Colors.white,fontSize: 15),),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.fromLTRB(25, 15, 25,15),
                          color: Colors.deepOrangeAccent,
                        ),
                        RaisedButton(
                          onPressed: selectImage,
                          child: Row(
                            children: <Widget>[
                              FaIcon(FontAwesomeIcons.image,color: Colors.white,),
                              SizedBox(width: 10,),
                              Text("Select ",
                                style: TextStyle(color: Colors.white,fontSize: 15),),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.fromLTRB(25, 15, 25,15),
                          color: Colors.deepOrangeAccent,
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    RaisedButton(
                      onPressed: () => uploadImage(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.upload,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Upload",
                            style: TextStyle(color: Colors.white,fontSize: 15),),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.fromLTRB(25, 15, 25,15),
                      color: Colors.green.shade400,
                    ),
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}