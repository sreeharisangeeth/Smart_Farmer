import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final userController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    RegExp regExp = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
      caseSensitive: false,
      multiLine: false,
    );

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Ubuntu',
      ),
      title: "Smart Farmer",
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 30,
            color: Colors.white,
            splashRadius: 25,
            onPressed: () => {
              Navigator.pop(context)
            },
          ),
          title: Text(
            'Smart Farmer',
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
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0x55b5c7ba),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 30),
                          RichText(
                            text: TextSpan(
                              text: 'Create an Account',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: TextField(
                              controller: userController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Full Name',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Email',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Password',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: TextField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Confirm Password',
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              text:
                                  "By creating an account you agree to our \n Terms of Service and Privacy Policy",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Colors.black87),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  color: Color(0xFF009966),
                  onPressed: () async {
                    if(userController.text.isEmpty || passwordController.text.isEmpty || emailController.text.isEmpty){
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("All fields are mandatory"),
                          );
                        },
                      );
                    }
                    else if(passwordController.text != confirmPasswordController.text){
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("Password mismatch"),
                          );
                        },
                      );
                    }
                    else if(!(regExp.hasMatch(emailController.text))){
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("Invalid Email ID"),
                          );
                        },
                      );
                    }
                    else{
                      var response = await http.post("https://smart-farmer-3.herokuapp.com/create?user=${userController.text}&email=${emailController.text}&password=${passwordController.text}");
                      var create = response.body;
                      if(create == "Success"){
                        Navigator.pop(context);
                      }
                      else{
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Invalid Credentials !"),
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
