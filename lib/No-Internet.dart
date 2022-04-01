import 'package:flutter/material.dart';


Widget _buildInternetStatus(){
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

       Icon(
         Icons.signal_wifi_off_sharp,
         size: 100,
         color: Color.fromRGBO(16, 10, 58, 0.8),
       ),
        SizedBox(height:20),
        Text(
          'Ops! kindly check your network connection',
          style: TextStyle(
            fontSize:20,
          ),
            textAlign: TextAlign.center,
        )
      ],
    ),
  );
}

Widget _buildTimeOut(){
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Icon(
          Icons.signal_wifi_off_sharp,
          size: 100,
          color: Color.fromRGBO(16, 10, 58, 0.8),
        ),
        SizedBox(height:20),
        Text(
          'network took too long. Kindly check your internet connection',
          style: TextStyle(
            fontSize:20,
          ),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}




class InternetStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: SafeArea(
              child: Center(
               child:Container(
                 child:_buildInternetStatus(),
               ),
              ),
            ),

    );
  }
}

class TimeOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child:Container(
            child:_buildTimeOut(),
          ),
        ),
      ),

    );
  }
}
