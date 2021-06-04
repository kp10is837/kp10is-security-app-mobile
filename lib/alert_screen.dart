import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/preferences.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class AlertScreen extends StatefulWidget{
  String heure = "";
  String date = "";
  String alarmFired = "";
  var alerte;

  AlertScreen({this.heure = "", this.date = "", this.alarmFired = "", this.alerte});
  _AlerteScreenState createState() => _AlerteScreenState(
    heure: this.heure,
    date: this.date,
    alarmFired: this.alarmFired,
    alerte: this.alerte
  );
}

class _AlerteScreenState extends State<AlertScreen>{
  String heure = "";
  String date = "";
  String alarmFired = "";
  var alerte;

  _AlerteScreenState({this.heure = "", this.date = "", this.alarmFired = "", this.alerte});

  var preferences;
  var user = ApiService.user;

  @override
  initState(){
    super.initState();
    this._getCurrentLocation();
  }

  getPreferences() async{
    preferences = await StreamingSharedPreferences.instance;
  }

  var _myPosition;
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _myPosition = position;
        print('position ${_myPosition.latitude.toString()}');
        // print('My position LAT ${position.latitude.toString()} LONG ${position.longitude}');
      });
    }).catchError((e) {
      print('error $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      /*appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.blue[900],
          title: Text('Alerte'),
        ),*/
      body: Container(
        width: double.infinity,
        color: Colors.grey[700],
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white)
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 25
              ),
              margin: EdgeInsets.only(
                  bottom: 10
              ),
              child: Text('$heure', style: TextStyle(fontSize: 25, color: Colors.white),),
            ),
            Container(
              child: Text('$date', style: TextStyle(fontSize: 17, color: Colors.white)),
              margin: EdgeInsets.only(
                  bottom: 25
              ),
            ),
            Container(
              child: Text(alarmFired=='2'?'Contrôle de présence':'Rappel',
                style: TextStyle(color: Colors.white, fontSize: 25),),
              margin: EdgeInsets.only(
                  bottom: 25
              ),
            ),
            Container(
              child: Text(alarmFired=='1'?'Votre intervention débute bientôt...':'',
                style: TextStyle(color: Colors.white, fontSize: 15),),
              margin: EdgeInsets.only(
                  bottom: 25
              ),
            ),
            Container(
              child: Text(alarmFired=='2'?'Cliquez pour pointer':'Cliquez pour arrêter l\'alarme',
                style: TextStyle(color: Colors.white, fontSize: 17),),
              margin: EdgeInsets.only(
                  bottom: 10
              ),
            ),
            InkWell(
              child: Container(
                height: MediaQuery.of(context).size.width/4,
                width: MediaQuery.of(context).size.width/4,
                decoration: BoxDecoration(
                  //color: Colors.red[900],
                    border: Border.all(
                        color: Colors.white
                    ),
                    borderRadius: BorderRadius.circular(100)
                ),
                child: Icon(Icons.check, color: Colors.white,size: MediaQuery.of(context).size.width/6,),
              ),
              onTap: () async {
                FlutterRingtonePlayer.stop();
                preferences = await StreamingSharedPreferences.instance;
                if(alarmFired == '1'){
                  setState(() {
                    alarmFired = '0';
                  });
                  preferences.setString("remember", "0");
                  Navigator.pop(context);
                  return;
                }
                preferences.setString("controle", "0");
                Utils.storePreference("0", "controle");
                var url = '${ApiService.autoControle}';
                DateTime actual = DateTime.now();
                String heureActuelle = DateFormat.Hm().format(actual);
                print('alerte $alerte');
                var data = {
                  'alerte_id': "${alerte['id']}",
                  'heure_alerte': '$heure',
                  'heure_pointage': '$heureActuelle',
                  'token': '${user['token']}',
                  'latitude': '${_myPosition?.latitude.toString()}',
                  'longitude': '${_myPosition?.longitude.toString()}',
                };
                var responseQuery = await ApiService.postData(context,url,data);
                print('reponse ${responseQuery.body}');
                var jsonResp = json.decode(responseQuery.body);
                if(responseQuery.statusCode==200) {
                  FlutterRingtonePlayer.stop();
                  setState(() {

                  });
                  if(jsonResp['status']=='OK'){
                    SharedPreferencesHelper.setValue("alarm_fired", "0");
                    setState(() {
                      alarmFired = '0';
                    });
                    Navigator.pop(context);
                  }
                  Toast.show("${jsonResp['message']}", context, gravity: Toast.TOP, duration: Toast.LENGTH_LONG);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}