import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'No-Internet.dart';
import 'package:connectivity/connectivity.dart';


class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  String _location;
  String _age;
  String _ethnicity;
  String _sex;
  String _dateState = 'please select a date';
  String _email;
  String _singleValueSex;
  String _singleValueDialogue;
  String _occupation;
  List _symptoms;
  DateTime _dateTime;
  String _symptomsResult;
  bool _dialogQuestion1;
  bool _dialogQuestion2;
  int _stackIndex = 0;
  String _verticalGroupValue = 'Pending';
  String _connectionStatus;
  StreamSubscription sub;
  bool isConnected = false;
  var response;
  String _date;





  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  @override
  void initState(){
    super.initState();
    _symptoms = [];
    _symptomsResult = '';
    sub = Connectivity().onConnectivityChanged.listen((result){
      setState((){
        isConnected = (result != ConnectivityResult.none);
      });
    });
  }

    @override
    void dispose(){
      sub.cancel();
      super.dispose();
    }

  _onSubmit() async{

  isConnected? _sendData() : _noNetWork();
}

  _ValidateStringData(data, value){
    if(value.isEmpty){
      return "kindly provide your $data";
    }

    if(data == 'email'){
      if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
        return "Please enter a valid email address";
      }
    }

    if (data == 'symptoms'){
          if(value  == null || value.length == 0){
            return "please provide your symptoms";
          }
    }
  }

  
  Future<void> _submitData() async{
    if(!_formkey.currentState.validate()){
      return;
    }
    _formkey.currentState.save();
    setState(() {
      _symptomsResult = _symptoms.toString();
    });
    _onSubmit();

  }

  Future<void> _sendData() async{

    _loaderModal(context);
    //final url = 'https://episurvapi.herokuapp.com/api';
    //final url = 'https://episurv.bodybycherry.com/api';
    final url = 'https://episurvapi.kingdomsecretonline.com/api';
    try {
      final response = await http.post(url, body: json.encode({
        'location': _location,
        'age': _age,
        'ethnicity_group': _ethnicity,
        'gender': _singleValueSex,
        'symptoms_date': _dateState,
        'email': _email,
        'travel': _singleValueDialogue,
        'symptoms': _symptomsResult,
        'occupation':_occupation,
      }));
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        return _showMessageDialog(context);
      }
    } catch(e) {
      Navigator.of(context).pop();
      return _timeOut();
    }
}

  _noNetWork(){
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InternetStatus(), fullscreenDialog: false),
    );
  }

  _timeOut(){
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimeOut(), fullscreenDialog: false),
    );
  }

  _showMessageDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
     return AlertDialog(
        content: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
              'Your report has been successfully submitted',
            //textAlign: TextAlign.center,
          ),
        ),
        actions: [
          FlatButton(
            child: Text('ok',
            style:TextStyle(
              fontSize: 20,
            ),
            ),
            onPressed: ()=>Navigator.of(context).pop(),
          )
        ],
      );
    });
  }


  _loaderModal(BuildContext context){
    return showDialog(context: context, builder: (context){
          return Scaffold(

            backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
            body:Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),

                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        SizedBox(width: 30),
                        Text('Reporting...')
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  });
}

  Widget _buildLocation(){
      return TextFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:Color.fromRGBO(16, 10, 58, 0.8),
            ),
              borderRadius: BorderRadius.circular(10)
          ),
          labelText: 'Location --postal code',
          labelStyle: TextStyle(
            color: Color.fromRGBO(16, 10, 58, 0.8),
          ),

        ),
          validator: (String value) => (_ValidateStringData('location', value)),
        onSaved: (String value){
          _location = value;
        }
      );
  }

  Widget _buildOccupation(){
    return TextFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:Color.fromRGBO(16, 10, 58, 0.8),
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          labelText: 'Occupation',
          labelStyle: TextStyle(
            color: Color.fromRGBO(16, 10, 58, 0.8),
          ),
        ),
        validator: (String value) => (_ValidateStringData('occupation', value)),
        onSaved: (String value){
          _occupation = value;
        }
    );
  }

  Widget _buildAge(){
    return TextFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:Color.fromRGBO(16, 10, 58, 0.8),
            ),
              borderRadius: BorderRadius.circular(10)
          ),
          labelText: 'Age',
          labelStyle: TextStyle(
            color: Color.fromRGBO(16, 10, 58, 0.8),
          ),
        ),
        validator: (String value) => (_ValidateStringData('age', value)),
        onSaved: (String value){
          _age = value;
        }
    );
  }

  Widget _buildEthnicity(){
    return TextFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:Color.fromRGBO(16, 10, 58, 0.8),
            ),
              borderRadius: BorderRadius.circular(10)
          ),
          labelText: 'Ethnicity',
          labelStyle: TextStyle(
            color: Color.fromRGBO(16, 10, 58, 0.8),
          ),
        ),
        validator: (String value) => (_ValidateStringData('ethnicity', value)),
        onSaved: (String value){
          _ethnicity = value;
        }
    );
  }

  Widget _buildSex(){
        return Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(16, 10, 58, 0.4),
            boxShadow: [
              BoxShadow(
              color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 10)
            ),],
          ),
          child: Padding(
            padding: EdgeInsets.all(10),

            child: Container(


              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children : <Widget>[
                  Text(
                      'Select your gender',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(16, 10, 58, 1),
                    fontWeight: FontWeight.bold
                  ),

                  ),
                IndexedStack(
                  children: <Widget>[
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                    RadioListTile(
                      title: Text(
                          "male",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      value: "male",
                      groupValue: _singleValueSex,
                      onChanged: (value) => setState(
                            () => _singleValueSex = value,
                      ),
                      activeColor: Color.fromRGBO(16, 10, 58, 0.8),


                    ),
                    RadioListTile(
                      title: Text(
                          "female",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      groupValue: _singleValueSex,
                      value: "female",
                      onChanged: (value) => setState(
                            () => _singleValueSex = value,
                      ),
                      activeColor: Color.fromRGBO(16, 10, 58, 0.8),
                    ),

                        RadioListTile(
                          title: Text(
                            "unspecified",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          groupValue: _singleValueSex,
                          value: "unspecified",
                          onChanged: (value) => setState(
                                () => _singleValueSex = value,
                          ),
                          activeColor: Color.fromRGBO(16, 10, 58, 0.8),
                        ),

                  ],
                ),
                ],
    )
                ],
              ),
            ),
          ),
        );
  }



  Widget _buildEmail(){
    return TextFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:Color.fromRGBO(16, 10, 58, 0.8),
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Color.fromRGBO(16, 10, 58, 0.8),
          ),
        ),
        validator: (String value) => (_ValidateStringData('email', value)),
        onSaved: (String value){
          _email = value;
        }
    );
  }

  Widget _buildSymptoms(){
      return MultiSelectFormField(


          checkBoxActiveColor: Color.fromRGBO(16, 10, 58, 0.8),
          chipBackGroundColor: Color.fromRGBO(16, 10, 58, 0.3),

          autovalidate: false,
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(16, 10, 58, 0.4),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    offset: Offset(0, 5)
                ),],
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  "Symptoms",
                style: TextStyle(
                  color: Color.fromRGBO(16, 10, 58, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
              ),
              ),
            ),
          ),
          dialogShapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          validator: (value) => (_ValidateStringData('symptoms', value)),
          dataSource: [
            {
              "display" : "Fever",
              "value" : "Fever"
            },

            {
              "display" : "Headache",
              "value" : "Headache"
            },

            {
              "display" : "Diarrhea",
              "value" : "Diarrhea"
            },

            {
              "display" : "Fatigue",
              "value" : "Fatigue"
            },

            {
              "display" : "Nausea",
              "value" : "Nausea"
            },

            {
              "display" : "Rash",
              "value" : "Rash"
            },

            {
              "display" : "Cough",
              "value" : "Cough"
            },

            {
              "display" : "Sore Throat",
              "value" : "Sore Throat"
            },

            {
              "display" : "Body Aches",
              "value" : "Body Aches"
            },

            {
              "display" : "Chills/ Night sweat",
              "value" : "Chills/ Night sweat"
            },

            {
              "display" : "Shortness of breath",
              "value" : "Shortness of breath"
            },

            {
              "display" : "Runny Nose",
              "value" : "Runny Nose"
            },
          ],
          textField: 'display',
          valueField: 'value',
          cancelButtonLabel: 'Cancel',
          hintWidget: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                  'please select one or more symptoms',
              )
          ),
          initialValue: _symptoms,
          onSaved: (value){
            if(value == null) return;
            setState(() {
              _symptoms = value;
            });
          },
        );
  }

  Widget _buildDialogQuestion1(){
    return Container(
       decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(10),
       color: Color.fromRGBO(16, 10, 58, 0.4),
         boxShadow: [
           BoxShadow(
               color: Colors.grey,
               blurRadius: 10,
               offset: Offset(0, 10)
           ),],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children : <Widget>[
            Text(
                'Have you travelled outside UK?',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(16, 10, 58,1),
                fontWeight: FontWeight.bold,
              ),
            ),
            IndexedStack(
              children: <Widget>[
                Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    RadioListTile(
                      title: Text(
                          "yes",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      value: "yes",
                      groupValue: _singleValueDialogue,
                      onChanged: (value) => setState(
                            () => _singleValueDialogue = value,
                      ),
                      activeColor: Color.fromRGBO(16, 10, 58, 0.8),


                    ),
                    RadioListTile(
                      title: Text(
                          "no",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      groupValue: _singleValueDialogue,
                      value: "no",
                      onChanged: (value) => setState(
                            () => _singleValueDialogue = value,
                      ),
                      activeColor: Color.fromRGBO(16, 10, 58, 0.8),
                    ),

                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }



  Widget _buildSymptomsDate(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(16, 10, 58, 0.4),
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: Offset(0, 10)
          ),],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                'When did you start noticing the symptoms?',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(16, 10, 58, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            FlatButton(
              child: Text('$_dateState',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: (){
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                ).then((date){
                  setState((){
                    //_dateTime = date;
                    _dateState = '${date.year.toString()}-${date.month.toString()}-${date.day.toString()}';

                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
            'Report your symptoms',
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(16, 10, 58, 0.8),
        elevation: 0,
      ),
     body: SafeArea(
           child: SingleChildScrollView(
             child: Form(
               key: _formkey,
               //padding: EdgeInsets.all(20),
               child: Container(
                 margin: EdgeInsets.all(25),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       _buildLocation(),
                       SizedBox(height: 30),
                       _buildOccupation(),
                       SizedBox(height: 30),
                       _buildAge(),
                       SizedBox(height: 30),
                       _buildEthnicity(),
                       SizedBox(height: 30),
                       _buildEmail(),
                       SizedBox(height: 30),
                       _buildSex(),
                       SizedBox(height: 30),
                       _buildDialogQuestion1(),
                       SizedBox(height: 30),
                       _buildSymptoms(),
                       SizedBox(height: 30),
                       _buildSymptomsDate(),
                       SizedBox(height: 40),

                    ElevatedButton(
                                child:Text(
                                    'submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  )
                                ),
                               //elevation: 50,
                               //color: Color.fromRGBO(16, 10, 58, 0.8),
                               onPressed: () {
                                 _submitData();
                                 print(isConnected);

                               },
                               style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                                 primary: Color.fromRGBO(16, 10, 58, 0.8),

                    ),
                                ),
                             ],
                             ),
                 ),
                           ),

             ),
           ),
         );
  }
}

