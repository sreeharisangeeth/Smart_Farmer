import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

class Index extends StatelessWidget{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
          padding: EdgeInsets.all(15),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x55b5c7ba),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget> [
                    SizedBox(height: 20),
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
                    SizedBox(height: 15),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    RaisedButton(
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      color: Color(0xFF009966),
                      onPressed: () async{
                        if(emailController.text.isEmpty || passwordController.text.isEmpty){
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: Center(child: Text("Invalid Credentials !",style: TextStyle(
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
                        else {
                          var response = await http.post("https://smart-farmer-3.herokuapp.com/validate?user=${emailController.text}&password=${passwordController.text}");
                          var connection = response.body;
                          if(connection == "True"){
                            await GlobalConfiguration().loadFromAsset("user");
                            var res = await http.post("https://smart-farmer-3.herokuapp.com/getname?user=${emailController.text}&password=${passwordController.text}");
                            GlobalConfiguration().updateValue("email", emailController.text);
                            GlobalConfiguration().updateValue("user", res.body);
                            Navigator.pushNamed(context, "/home");
                          }
                          else{
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                      child: Center(child: Text("Invalid Credentials !",style: TextStyle(
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
                      },
                    ),
                    Divider(
                      color: Colors.black12,
                      height: 30,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                    Center(
                      child: RaisedButton(
                        child: Text(
                          "Create an account",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        color: Colors.deepOrangeAccent,
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign_up');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}