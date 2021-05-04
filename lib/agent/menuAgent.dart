import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/connexion.dart';
import 'package:negomer_mobile/controleur/scanCode.dart';
import 'package:negomer_mobile/scanner.dart';
import 'package:negomer_mobile/utils/preferences.dart';

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
                      firstName + ' ' + lastName,
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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Connexion();
    }));
  }

  Future<Null> confirmDialog(BuildContext context, void onNo(), void onYes()) {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Êtes vous sûr de vous déconnecter ?'),
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
