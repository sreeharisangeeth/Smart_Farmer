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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class _ScannerState extends State<Scanner> {

  File _image;
  final _picker = ImagePicker();
  String cropName = "";
  String cropAlt="Select an image to start";
  final cropController = TextEditingController();


  showLoaderDialog(BuildContext context){
    AlertDialog alert = AlertDialog(
      content: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
          SizedBox(height: 15,),
          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.green.shade600),
          ),
          SizedBox(height: 15,),
          Text("Uploading..." ),
          SizedBox(height: 15,),
        ],
      ),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }


  cropNameUpload() {
    FocusScope.of(context).unfocus();
    showLoaderDialog(context);
    if(cropController.text.isNotEmpty){
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Suggestion(cropName: (cropController.text.toLowerCase()).capitalize(),image: null,),
          ));
    }
    else{
      Navigator.pop(context);
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: Center(child: Text("Crop name can't be empty",style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.red,
                ),))
            ),
            actions: <Widget>[
              TextButton(
                child: Text('close',style: TextStyle(color: Colors.black87,fontSize: 18.0,),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  uploadImage() async{
    showLoaderDialog(context);
    String fileName = _image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image":
      await MultipartFile.fromFile(_image.path, filename:fileName),
    });
    var response = await Dio().post("https://smart-farmer-3.herokuapp.com/identify", data: formData);
    if(response.statusCode == 404)
      {
        Navigator.pop(context);
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SingleChildScrollView(
                  child: Center(child: Text("Crop not found",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.red,
                  ),))
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('close',style: TextStyle(color: Colors.black87,fontSize: 18.0,),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    setState(() {
      this.cropName = response.data;
    });
    Navigator.pop(context);
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
                    Row(
                      children: <Widget> [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: MediaQuery.of(context).size.width*0.67,
                          child: TextField(
                            controller: cropController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              hintText: 'Enter a crop name',
                              suffixIcon: IconButton(
                                onPressed: (){
                                  cropController.clear();
                                  FocusScope.of(context).unfocus();
                                },
                                icon: FaIcon(FontAwesomeIcons.times,size: 15,),
                              ),
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: cropNameUpload,
                          color: Colors.red.shade400,
                          child: FaIcon(FontAwesomeIcons.search,color: Colors.white,),
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                        children: <Widget>[
                          Expanded(
                              child: Divider(
                                thickness: 2,
                                endIndent: 5,
                              )
                          ),

                          Text("OR"),

                          Expanded(
                              child: Divider(
                                thickness: 2,
                                indent: 5,
                              )
                          ),
                        ]
                    ),
                    SizedBox(height: 30,),
                    _image == null ? Text(cropAlt) : ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.file(_image,),
                    ),
                    SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.1, 15, MediaQuery.of(context).size.width*0.1,15),
                          color: Colors.deepOrangeAccent,
                        ),
                        SizedBox(width: 15,),
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
                          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.1, 15, MediaQuery.of(context).size.width*0.1,15),
                          color: Colors.deepOrangeAccent,
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
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