import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/controleur/detailsInterventions.dart';
import 'package:negomer_mobile/utils/preferences.dart';

class AcceuilP1 extends StatefulWidget {
  @override
  _AcceuilP1State createState() => _AcceuilP1State();
}

class _AcceuilP1State extends State<AcceuilP1> {
  bool isLoading = false;
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
    _getDatas();
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

  Future<Null> _getDatas() async {
    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return !isLoading
        ? Column(
            children: [
              Column(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical: hauteur / 40, horizontal: largeur / 20),
                      child: Card(
                          elevation: 10,
                          shadowColor: Colors.black38,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(largeur / 10),
                                    bottomRight:
                                        Radius.circular(largeur / 10))),
                            padding: EdgeInsets.symmetric(
                                vertical: hauteur / 40,
                                horizontal: largeur / 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                    "assets/user1.png",
                                  ),
                                  radius: largeur / 25,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '\t\t\t' + firstName + ' ' + lastName,
                                      style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      typeUser,
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ))),
                ],
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: largeur / 17),
                child: Row(
                  children: [
                    Text(
                      'Mes statistiques\n',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.black45,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.blueGrey[50],
                padding: EdgeInsets.symmetric(
                    vertical: hauteur / 40, horizontal: largeur / 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: largeur / 3.5,
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.black38,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: hauteur / 60, horizontal: largeur / 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nombre d'interventions\n",
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                '23',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: largeur / 3.5,
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.black38,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: hauteur / 60, horizontal: largeur / 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Interventions confirmées\n",
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                '15',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: largeur / 17),
                child: Row(
                  children: [
                    Text(
                      '\nListe des interventions',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Container(
                height: hauteur / 1.35,
                color: Colors.blueGrey[50],
                child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          detailIntervention(context, largeur, hauteur);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: hauteur / 80, horizontal: largeur / 25),
                          child: Card(
                            elevation: 10,
                            shadowColor: Colors.black38,
                            child: Container(
                                width: largeur,
                                decoration: BoxDecoration(
                                    color: Colors.red[300],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    )),
                                padding: EdgeInsets.symmetric(
                                    vertical: hauteur / 60,
                                    horizontal: largeur / 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Intervenant\n",
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          'Abdou baki',
                                          style: GoogleFonts.lato(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Début\n",
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          '18h : 45m',
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Fin\n",
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          '02h : 45m',
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          )
        : Stack(
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          );
  }
}
