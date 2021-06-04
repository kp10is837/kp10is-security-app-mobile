import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/success_page.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:negomer_mobile/widget/loading_data.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class PointageScreen extends StatefulWidget{
  @override
  _PointageScreenState createState() => _PointageScreenState();
}

class _PointageScreenState extends State<PointageScreen>{
  var user = ApiService.user;
  String status = 'OK';
  String heureAutorise = '';
  String message = '';
  var intervention;
  bool loading = true;
  int typePointage = 0;

  @override
  initState(){
    super.initState();
    initPointing();
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

  initPointing() async{
    setState(() {
      loading = true;
    });
    _getCurrentLocation();
    var responseQuery = await ApiService.getData('${ApiService.initPointing}?token=${user['token']}');
    print('responseQuery.body ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {
        status = '${jsonResp['status']}';
        heureAutorise = '${jsonResp['heure_autorise']}';
        intervention = jsonResp['intervention'];
        typePointage = jsonResp['type_pointage'];
        message = jsonResp['message'];
        loading = false;
      });

      //Toast.show('type $typePointage', context);
    }
  }

  normalPointing({String? reason}) async{
    String url = '${ApiService.pointing}';
    var data;
    if(Utils.empty(reason)){
      data = {
        'token':'${user['token']}',
        'intervention_id':'${intervention['id']}',
        'type_pointage':'$typePointage}',
        'latitude': '${_myPosition.latitude.toString()}',
        'longitude': '${_myPosition.longitude.toString()}',
      };
    }
    else{
      data = {
        'token':'${user['token']}',
        'intervention_id':'${intervention['id']}',
        'type_pointage':'$typePointage}',
        'latitude': '${_myPosition?.latitude.toString()}',
        'longitude': '${_myPosition?.longitude.toString()}',
        'raison_pointage': '$reason'
      };
    }
    var responseQuery = await ApiService.postData(context,url,data);
    print('reponse ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {

      });
      if(jsonResp['status']=='OK'){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage('${jsonResp['message']}', reload: true,)),
        ).then((value) {
          initPointing();
        });
      }
    }
  }

  TextEditingController _textFieldController = TextEditingController();
  _displayDialog(BuildContext context) async {
    _textFieldController.text = '';
    final _formKey = GlobalKey<FormState>();
    var rate = 0.0;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //title: Text('Votre avis'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 15
                    ),
                    child: Text('Vous êtes sur le point de mettre fin à votre intervention plus tôt que prévu. Veuillez donner une justification pour continuer.'),
                  ),
                  TextField(
                    controller: _textFieldController,
                    maxLines: 3,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Votre justification",
                      hintStyle: GoogleFonts.lato(
                          fontStyle: FontStyle.normal,
                          color: Colors.blueGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 20
                    ),
                  ),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () async{
                        if(Utils.empty(_textFieldController.text)){
                          Toast.show('Veullez renseigner votre justificatif', context, duration: Toast.LENGTH_LONG*3, gravity: Toast.TOP);
                          return;
                        }
                        if (await confirm(
                          context,
                          title: Text('Confirmation'),
                          content: Text('Votre présence sera enregistrée. Voulez vous continuer ?'),
                          textOK: Text('Oui'),
                          textCancel: Text('Non'),
                        )) {
                          //Enregistrer la présence
                          Navigator.pop(context);
                          normalPointing(
                              reason: _textFieldController.text
                          );
                        }
                        return print('pressedCancel');
                      },
                      color: Colors.blue[900],
                      textColor: Colors.white,
                      child: Text(
                        "Valider",
                        style: GoogleFonts.lato(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ],
              ),
            ),
            /*actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],*/
          );
        });
  }

  pointingEnd() async {

  }

  pointing() {
    if(Utils.empty(intervention)){
      //Toast.show("Vous avez déjà pointé pour la fin de votre intervention", context, duration: Toast.LENGTH_LONG*3, gravity: Toast.TOP);
      return;
    }
    DateTime actual = DateTime.now();
    String heureActuelle = DateFormat.Hm().format(actual);
    DateTime dt_autorise = DateTime.parse('${Utils.formatDateTime(intervention['date_intervention'], 'yyyy-MM-dd')} $heureAutorise');
    DateTime dt_actuel = DateTime.parse('${Utils.formatDateTime(intervention['date_intervention'], 'yyyy-MM-dd')} $heureActuelle');
    print('date now $dt_actuel');
    print('date autorise $dt_autorise');
    if(typePointage == 1){
      confirmPointing();
    }
    else{
      if(dt_actuel.isBefore(dt_autorise)){
        print('Peux pas pointer');
        _displayDialog(context);
      }
      else{
        confirmPointing();
      }
    }

  }

  confirmPointing() async{
    if (await confirm(
      context,
      title: Text('Confirmation'),
      content: Text('Votre présence sera enregistrée. Voulez vous continuer ?'),
      textOK: Text('Oui'),
      textCancel: Text('Non'),
    )) {
      //Enregistrer la présence
      normalPointing();
    }
    return print('pressedCancel');
  }

  getView(){
    return !loading?
    typePointage!=0 ?
    Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16
            ),
            alignment: Alignment.center,
            child: Text(typePointage==1?'Cliquez sur ce bouton pour marquer le début de votre intervention':
            'Cliquez sur ce bouton pour marquer la fin de votre intervention',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ),
          //Utils.empty(intervention['heure_pointage_debut']) || Utils.empty(intervention['heure_pointage_fin'])?
          Utils.empty(intervention)?
          InkWell(
            child: Container(
              height: MediaQuery.of(context).size.width/3.5,
              width: MediaQuery.of(context).size.width/3.5,
              decoration: BoxDecoration(
                  color: (typePointage==1)?Colors.blue[900]:(typePointage==2)?Colors.red[900]:Colors.white,
                  borderRadius: BorderRadius.circular(100)
              ),
              child: (typePointage==1)?Icon(
                Icons.play_arrow,
                size: MediaQuery.of(context).size.width/6,
                color: Colors.white,
              ):Icon(
                Icons.stop,
                size: MediaQuery.of(context).size.width/6,
                color: Colors.white,
              ),
            ),
            onTap: (){
              pointing();
            },
          ):Container(),
        ],
      ),
    ):
            Container()
        /*Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 25
            ),
            child: Text('$message', style: TextStyle(fontSize: 20, color: Colors.grey[600]),textAlign: TextAlign.center,),
          ),
        )*/:
        Container();
    //LoadingData(45);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    /*return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Pointage'),
        brightness: Brightness.dark,
      ),
      body: getView(),
    );*/
    if(typePointage!=0)
      return InkWell(
        child: Container(
        height: MediaQuery.of(context).size.width/3.5,
        width: MediaQuery.of(context).size.width/3.5,
        decoration: BoxDecoration(
            color: (typePointage==1)?Colors.blue[900]:Colors.red[900],
            borderRadius: BorderRadius.circular(100)
        ),
        child: (typePointage==1)?Icon(
          Icons.play_arrow,
          size: 30,
          color: Colors.white,
        ):Icon(
          Icons.stop,
          size: 30,
          color: Colors.white,
        ),
      ),
        onTap: (){
          pointing();
        },
      );
     else return Container();
  }
}