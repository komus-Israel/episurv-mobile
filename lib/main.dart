import 'dart:ffi';
import 'dart:async';
import 'package:flutter/material.dart';
import 'form-page1.dart';
import 'No-Internet.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.deepPurpleAccent,
    ),
    home: SplashScreen(),
    routes: {
      '/home' :(context)=>FormPage(),
      '/noInternet' : (context) => InternetStatus()
    },
  ));
}

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), (){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context){
                return FormPage();
              }
          ),
              (route) => false);
    });
  }


  void _openForm({
  BuildContext context, bool fullscreenDialog = true
}){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormPage(), fullscreenDialog: fullscreenDialog),
    );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color.fromRGBO(16, 10, 58, 0.8),
      body: SafeArea(
        child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*Image(
                    image: AssetImage('assets/images/splash-screen-logo.png'),
                    height: 200,
                  ),*/

                  Expanded(
                    child: CircleAvatar(
                      backgroundColor:Colors.white,
                      radius: 60,
                      child: Icon(
                        Icons.medical_services_sharp,
                       // color: Color.fromRGBO(16, 10, 58, 0.8),
                        color: Colors.deepOrange,
                        size:50,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
              Expanded(
                child:Text(
                  'EPISURV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,

                ),
              ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(
                            strokeWidth: 2,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0,0,10)
                        ),
                        Text(
                          'report your symptoms today',
                          style: TextStyle(
                            color: Colors.white60,
                            letterSpacing: 2,
                          ),

                        ),
                      ],
                    ),


                  ),
                ],
              ),
            ),
        )
      );
  }
}
