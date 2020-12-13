import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';


class Scanner extends StatefulWidget{
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  File _image;
  final _picker = ImagePicker();

  Future captureImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        this._image = File(pickedFile.path);
      }
      else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        this._image = File(pickedFile.path);
      }
      else {
        print('No image selected.');
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
                    _image == null ? Text("Select an image to start") : ClipRRect(
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
                          onPressed: uploadImage,
                          child: Row(
                            children: <Widget>[
                              FaIcon(FontAwesomeIcons.image,color: Colors.white,),
                              SizedBox(width: 10,),
                              Text("Upload",
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
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}