import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/services/inputDecoration.dart';
import 'package:negomer_mobile/utils/contants.dart';
import 'package:http/http.dart' as http;
import 'package:negomer_mobile/utils/preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:negomer_mobile/utils/utils.dart';
//import 'package:negomer_mobile/agent/AcceuilProfileAgent.dart';

import 'AcceuilProfile.dart';

class Connexion extends StatefulWidget {
  Connexion();

  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  String login = '';
  String password = '';
  String erreur = '';
  Map navigation = {};
  bool _isloading = false;

  Map data = {};

  final _keyForm = GlobalKey<FormState>();

  late StreamSubscription<DataConnectionStatus> listener;
  var InternetStatus = "Unknown";
  var contentmessage = "Unknown";

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Container(
          constraints: BoxConstraints.expand(),
          //width: double.infinity,
          //height: hauteur,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/FondConnexion.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma(),
            ),
          ),
          child: Container(
            height: hauteur,
            padding: EdgeInsets.symmetric(horizontal: largeur / 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _keyForm,
                  child: Container(
                    child: Container(
                      //color: Colors.white12.withOpacity(0.1),
                      padding: EdgeInsets.symmetric(
                        horizontal: largeur / 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'CONNEXION',
                            style: GoogleFonts.lato(
                              fontSize: 35,
                              color: Colors.indigo[900],
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            'Bienvenue sur Negomer',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.indigo[600],
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: hauteur / 10,
                          ),
                          TextFormField(
                            initialValue:
                                data != null ? data['identifiant'] : '',
                            decoration: inputDecoration("Identifiant", largeur),
                            validator: (val) => val!.isEmpty
                                ? 'Veuillez entrer votre identifiant'
                                : null,
                            onChanged: (val) => this.login = val,
                          ),
                          SizedBox(height: hauteur / 45),
                          TextFormField(
                            decoration:
                                inputDecoration("Mot de passe", largeur),
                            onChanged: (val) => this.password = val,
                            validator: (val) => val!.length < 6
                                ? 'Veuillez entrer au moins 6 caractères'
                                : null,
                            obscureText: true,
                          ),
                          SizedBox(height: hauteur / 20),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.all(15),
                            onPressed: () {
                              if (_keyForm.currentState!.validate()) {
                                checkConnection(context);
                              }
                            },
                            child: _isloading
                                ? Center(
                                    heightFactor: 0.38,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Wrap(
                                          children: [
                                            Text(
                                              'Se connecter',
                                              style: GoogleFonts.lato(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                            color: Colors.indigo[700],
                          ),
                          Text(
                            this.erreur,
                            style: GoogleFonts.lato(
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: hauteur / 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  connexion(login, password) async {
    setState(() {
      _isloading = true;
    });
    final response = await http.post(
        Uri.parse(ApiService.apiHost + "auth/login?token=" + Constants.token),
        body: {'login': login, 'password': password});
    print(response.body);
    var dataUser = json.decode(response.body);
    if (dataUser['error'] == true) {
      setState(() {
        _isloading = false;
      });
      _showAlertDialog('Désolé',
          'Identifiant ou Mot de passe incorrect! Veuillez réessayer.');
    } else {
      print(dataUser['message']);
      print(dataUser['user']);
      SharedPreferencesHelper.setValue(
          "telephone", dataUser['user']["telephone"]);
      SharedPreferencesHelper.setValue(
          "last_name", dataUser['user']["last_name"]);
      SharedPreferencesHelper.setValue(
          "first_name", dataUser['user']["first_name"]);
      SharedPreferencesHelper.setValue("login", dataUser['user']["login"]);
      SharedPreferencesHelper.setValue("email", dataUser['user']["email"]);
      SharedPreferencesHelper.setValue("token", dataUser['user']["token"]);
      if (dataUser['user']["type_client"] != null)
        SharedPreferencesHelper.setIntValue(
            "type_client", int.parse('${dataUser['user']["type_client"]}'));
      SharedPreferencesHelper.setIntValue("id", dataUser['user']["id"]);
      SharedPreferencesHelper.setValue(
          "quartier", dataUser['user']["quartier"]);
      SharedPreferencesHelper.setValue("token", dataUser['user']["token"]);
      SharedPreferencesHelper.setValue("ville", dataUser['user']["ville"]);
      SharedPreferencesHelper.setValue(
          "raison_sociale", dataUser['user']["raison_sociale"]);
      if (dataUser['user']["type_user"] != null)
        SharedPreferencesHelper.setIntValue(
            "type_user", int.parse('${dataUser['user']["type_user"]}'));
      SharedPreferencesHelper.setIntValue("step_auth", 1);

      //store user jsonin preference
      var jsonUser = dataUser['user'];
      var encodeJsonUser = jsonEncode(jsonUser);
      String userString =
          encodeJsonUser; //.substring(0, encodeJsonUser.length - 1);
      ApiService.user = dataUser['user'];
      Utils.storePreference(userString, "user");

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return AcceuilProfile();
      }));
      //Navigator.pushReplacementNamed(context, "/acceuilProfile",
      //  arguments: {"login": login});
      /*if (int.parse(dataUser['user']["is_admin"]) == 1) {
      } else {}*/
    }
  }

  void _showAlertDialog(String title, String content) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  void _showDialog(String title, String content, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text(title),
              content: new Text(content),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Fermer"))
              ]);
        });
  }

  checkConnection(BuildContext context) async {
    setState(() {
      _isloading = true;
    });
    connexion(this.login, this.password);
    /*listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          //InternetStatus = "Connected to the Internet";
          //contentmessage = "Connected to the Internet";
          //_showDialog(InternetStatus, contentmessage, context);
          setState(() {
            _isloading = true;
          });
          connexion(this.login, this.password);
          break;
        case DataConnectionStatus.disconnected:
          InternetStatus = "Vous n'avez pas d'accès d'internet. ";
          contentmessage = "Veuillez-vous connecter à internet SVP";
          _showDialog(InternetStatus, contentmessage, context);
          break;
      }
    });*/
    //return await DataConnectionChecker().connectionStatus;
  }
}
