import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/change_password_screen.dart';
//import 'package:negomer_mobile/agent/AcceuilProfileAgent.dart';
import 'package:negomer_mobile/connexion.dart';
import 'package:negomer_mobile/monCodeQR.dart';
import 'package:negomer_mobile/pointage_screen.dart';
import 'package:negomer_mobile/scanCode.dart';
import 'package:negomer_mobile/scanner.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/preferences.dart';
import 'package:negomer_mobile/postes_screen.dart';
import 'package:negomer_mobile/report_screen.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:negomer_mobile/settings_screen.dart';

import 'AcceuilProfile.dart';

class Menu extends StatefulWidget {
  Menu();

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String telephone = "";
  String firstName = "";
  String lastName = "";
  String login = "";
  String email = "";
  String typeUser = "";
  var user = ApiService.user;

  Future<String> telephonePreferences =
      SharedPreferencesHelper.getValue("telephone");
  Future<int> typeUserPreferences =
      SharedPreferencesHelper.getIntValue("type_user");
  Future<String> firstNamePreferences =
      SharedPreferencesHelper.getValue("first_name");
  Future<String> lastNamePreferences =
      SharedPreferencesHelper.getValue("last_name");
  Future<String> loginPreferences = SharedPreferencesHelper.getValue("login");
  Future<String> emailPreferences = SharedPreferencesHelper.getValue("email");

  @override
  void initState() {
    super.initState();
    typeUserPreferences.then((int value) async {
      setState(() {
        if (value == 1) {
          typeUser = "Agent";
        } else if (value == 2) {
          typeUser = "Contrôleur";
        } else if (value == 3) {
          typeUser = "Client";
        }
      });
    });
    telephonePreferences.then((String value) async {
      setState(() {
        telephone = value;
      });
    });
    emailPreferences.then((String value) async {
      setState(() {
        email = value;
      });
    });
    loginPreferences.then((String value) async {
      setState(() {
        login = value;
      });
    });
    firstNamePreferences.then((String value) async {
      setState(() {
        firstName = value;
      });
    });
    lastNamePreferences.then((String value) async {
      setState(() {
        lastName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;

    return Container(
      width: largeur / 1.25,
      decoration: BoxDecoration(
          color: Colors.indigo[50],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                    )),
                height: 200,
                width: 500,
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/user1.png'),
                      radius: 40,
                    ),
                    SizedBox(
                      width: 0,
                    ),
                    Text(
                      Utils.empty(firstName) && Utils.empty(lastName)
                          ? '${ApiService.user['raison_sociale']}'
                          : firstName + ' ' + lastName,
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                    Text(
                      email,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.blue,
                width: largeur / 1.25,
                height: hauteur / 40,
              ),
              Container(
                color: Colors.blue[100],
                width: largeur / 1.25,
                height: hauteur / 80,
              ),
              SizedBox(
                height: hauteur / 40,
              ),
              typeUser == "Contrôleur" ? Divider() : Container(),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("ACCUEIL", style: GoogleFonts.lato()),
                onTap: () {
                  setState(() {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new AcceuilProfile();
                    }));
                  });
                },
              ),
              typeUser == "Contrôleur" || typeUser == "Client" && !Utils.empty(user['parent'])
                  ? Divider()
                  : Container(),
              typeUser == "Contrôleur" || typeUser == "Client" && !Utils.empty(user['parent'])
                  ? ListTile(
                      leading: Icon(Icons.pages),
                      title: Text("SCANNER UN INTERVENANT",
                          style: GoogleFonts.lato()),
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ScanCode()),
                          );
                        });
                      },
                    )
                  : Container(),
              typeUser == "Agent" ? Divider() : Container(),
              typeUser == "Agent"
                  ? ListTile(
                      leading: Icon(Icons.pages),
                      title: Text("MON CODE QR", style: GoogleFonts.lato()),
                      onTap: () {
                        setState(() {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) {
                            return new MonCodeQR();
                          }));
                        });
                      },
                    )
                  : Container(),
              /*typeUser == "Agent" ? Divider() : Container(),
              typeUser == "Agent"
                  ? ListTile(
                leading: Icon(Icons.check),
                title: Text("POINTAGE", style: GoogleFonts.lato()),
                onTap: () {
                  setState(() {
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (BuildContext context) {
                          return new PointageScreen();
                        }));
                  });
                },
              )
                  : Container(),*/
              typeUser == "Client" && Utils.empty(user['parent']) ? Divider() : Container(),
              typeUser == "Client" && Utils.empty(user['parent'])
                  ? ListTile(
                      leading: Icon(Icons.list),
                      title: Text("MES POSTES D'INTERVENTION",
                          style: GoogleFonts.lato()),
                      onTap: () {
                        setState(() {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) {
                            return new AcceuilProfile(
                              selectedIndex: 1,
                            );
                          }));
                        });
                      },
                    )
                  : Container(),
              Divider(),
              typeUser == "Client" && !Utils.empty(user['parent'])?
              ListTile(
                leading: Icon(Icons.report),
                title: Text("SIGNALER UNE URGENCE",
                    style: GoogleFonts.lato()),
                onTap: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReportScreen()),
                    );
                  });
                },
              ):Container(),
              typeUser == "Client" && !Utils.empty(user['parent'])?
              Divider():
              Container(),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text("MODIFIEZ VOTRE MOT DE PASSE",
                    style: GoogleFonts.lato()),
                onTap: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                    );
                  });
                },
              ),typeUser == "Agent" ? Divider() : Container(),
              typeUser == "Agent"
                  ? ListTile(
                leading: Icon(Icons.settings),
                title: Text("PARAMETRES", style: GoogleFonts.lato()),
                onTap: () {
                  setState(() {
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (BuildContext context) {
                          return new SettingsScreen();
                        }));
                  });
                },
              )
                  : Container(),
              Divider(),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("POLITIQUE DE CONFIDENTIALITE",
                    style: GoogleFonts.lato()),
                onTap: () {},
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              new Positioned(
                  child: new Container(
                margin: EdgeInsets.all(20),
                height: hauteur / 12,
                width: largeur,
                decoration: new BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(50)),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.all(10),
                  color: Colors.blue[900],
                  child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      children: [
                        Text(
                          'Déconnexion',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    deconnexion();
                  },
                ),
              )),
            ],
          )
        ],
      ),
    );
  }

  deconnexion() {
    var onYes = () {
      //print('Oui');
      _quit();
    };
    var onNo = () {
      //print('Non');
      Navigator.pop(context);
    };
    confirmDialog(context, onNo, onYes).then((_) {
      //print('Done');
    });
  }

  _quit() async {
    SharedPreferencesHelper.setIntValue("step_auth", 0);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Connexion()),
        (Route<dynamic> route) => false);
    /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Connexion();
    }));*/
  }

  Future<Null> confirmDialog(BuildContext context, void onNo(), void onYes()) {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Êtes-vous sûr(e) de vouloir vous déconnecter ?',
              style: GoogleFonts.lato(
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Oui'),
                onPressed: () {
                  onYes();
                },
              ),
              FlatButton(
                child: const Text('Non'),
                onPressed: () {
                  onNo();
                },
              ),
            ],
          );
        });
  }
}
