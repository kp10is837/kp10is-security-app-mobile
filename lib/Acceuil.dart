import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'connexion.dart';

class Acceuil extends StatefulWidget {
  Acceuil();

  @override
  _AcceuilState createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Container(
            color: Colors.white,
            height: hauteur,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: hauteur / 8,
                  ),
                  Center(
                      child: Text(
                    'Bienvenue sur',
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      color: Colors.indigo[600],
                      fontWeight: FontWeight.w400,
                    ),
                  )),
                  Center(
                      child: Text(
                    'NEGOMER',
                    style: GoogleFonts.lato(
                      fontSize: largeur / 10,
                      color: Colors.indigo[600],
                      fontWeight: FontWeight.w900,
                    ),
                  )),
                  SizedBox(height: hauteur / 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: largeur / 10),
                        child: Container(
                          child: Image.asset("assets/acceuilImage.png",
                              width: largeur / 2,
                              height: hauteur / 3,
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(
                        height: hauteur / 20,
                      ),
                      Center(
                        child: Text(
                          "NEGOMER SECURITE,\n Une agence modèle et réussie pour la sécurité des biens et personnes.",
                          style: GoogleFonts.lato(
                              fontStyle: FontStyle.normal,
                              color: Colors.blueGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: hauteur / 20,
                  ),
                  RaisedButton(
                    color: Colors.indigo[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "CONNEXION",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                      ),
                    ),
                    padding: EdgeInsets.all(hauteur / 43),
                    onPressed: connexion,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void connexion() {
    setState(() {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new Connexion();
      }));
    });
  }
}
