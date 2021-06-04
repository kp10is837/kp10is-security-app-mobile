import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/services/detailIntervention.dart';
import 'package:negomer_mobile/utils/preferences.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:negomer_mobile/widget/actual_intervention_widget.dart';
import 'package:negomer_mobile/widget/coming_intervention_widget.dart';
import 'package:negomer_mobile/widget/loading_data.dart';
import 'package:negomer_mobile/widget/no_data.dart';

class AcceuilP1 extends StatefulWidget {
  @override
  _AcceuilP1State createState() => _AcceuilP1State();
}

class _AcceuilP1State extends State<AcceuilP1> {
  String telephone = "";
  String firstName = "";
  String lastName = "";
  String login = "";
  String email = "";
  String typeUser = "";
  String tokenUser = "";
  var chiffres;
  bool loading = true;
  var user = ApiService.user;

  var actualInterventions = [];
  var comingInterventions = [];

  Future<String> telephonePreferences =
      SharedPreferencesHelper.getValue("telephone");
  Future<int> typeUserPreferences =
      SharedPreferencesHelper.getIntValue("type_user");
  Future<String> firstNamePreferences =
      SharedPreferencesHelper.getValue("first_name");
  Future<String> lastNamePreferences =
      SharedPreferencesHelper.getValue("last_name");
  Future<String> tokenPreferences = SharedPreferencesHelper.getValue("token");

  Future<String> loginPreferences = SharedPreferencesHelper.getValue("login");
  Future<String> emailPreferences = SharedPreferencesHelper.getValue("email");

  @override
  void initState() {
    super.initState();
    //Utils.getAuthUser();
    //user = ApiService.user;
    print('uesr user $user');
    if ('${user['type_user']}' == '1') {
      typeUser = "Agent";
    } else if ('${user['type_user']}' == '2') {
      typeUser = "Contrôleur";
    } else if ('${user['type_user']}' == '3') {
      typeUser = "Client";
    }
    lastName = user['last_name'];
    firstName = user['first_name'];
    telephone = user['telephone'];
    email = user['email'];
    login = user['login'];
    /*typeUserPreferences.then((int value) async {
      setState(() {
        if (value == 1) {
          typeUser = "Agent";
        } else if (value == 2) {
          typeUser = "Contrôleur";
        } else if (value == 3) {
          typeUser = "Client";
        }
      });
    });*/
    /*tokenPreferences.then((String value) async {
      setState(() {
        tokenUser = value;
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
    });*/
    loadData();
  }

  loadData() async {
    //loading = true;
    print('tokenuser1 $tokenUser');
    print('tokenuser2 ${user['token']}');
    Utils.getAuthUser();
    //user = ApiService.user;
    String url = '${ApiService.userDashboard}?token=${user['token']}';
    print('user token ${user['token']}');
    var responseQuery = await ApiService.getData(url);
    print('MyResponseQuery.body ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if (responseQuery.statusCode == 200) {
      setState(() {
        actualInterventions = (jsonResp['actual_interventions']);
        comingInterventions = (jsonResp['coming_interventions']);
        chiffres = jsonResp['chiffres'];
        print('actualInterventions $actualInterventions');
        print('coming $comingInterventions');
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: !loading
          ? SizedBox(
              height: hauteur * 3 / 4,
              child: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: hauteur / 100,
                              horizontal: largeur / 20),
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.black38,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft:
                                            Radius.circular(largeur / 10),
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
                                          Utils.empty(firstName) &&
                                                  Utils.empty(lastName)
                                              ? '\t\t\t${ApiService.user['raison_sociale']}'
                                              : '\t\t\t' +
                                                  firstName +
                                                  ' ' +
                                                  lastName,
                                          style: GoogleFonts.lato(
                                            fontSize: 18,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w900,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          '\t\t' + typeUser,
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
                    padding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: largeur / 17),
                    child: Row(
                      children: [
                        Text(
                          'Mon activité\n',
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: typeUser != "Contrôleur"
                        ? typeUser == "Agent"
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      width: largeur / 3.5,
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.black38,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Interventions effectuées\n\n",
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                '${chiffres['nb_effectuees_agent']}',
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
                                  ),
                                  /*Expanded(
                                    child: Container(
                                      width: largeur / 3.5,
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.black38,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Interventions controlées\n\n",
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                '${chiffres['nb_controlees_agent']}',
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
                                    flex: 5,
                                  ),*/
                                  Expanded(
                                    child: Container(
                                      width: largeur / 3.5,
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.black38,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Interventions à venir\n\n",
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                '${comingInterventions.length}',
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
                                    flex: 5,
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      width: largeur / 3.5,
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.black38,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Interventions effectuées\n\n",
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                '${chiffres['nb_effectuees_client']}',
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
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      width: largeur / 3.5,
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.black38,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Interventions contrôlées\n\n",
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                '${chiffres['nb_controlees_client']}',
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
                                  ),
                                  typeUser == "Client" && Utils.empty(user['parent']) ?
                                  Expanded(
                                    child: Container(
                                      width: largeur / 3.5,
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.black38,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Postes d'intervention\n\n",
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                '${chiffres['nb_postes']}',
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
                                    flex: 5,
                                  ):
                                  Container(),
                                ],
                              )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  //width: largeur / 3.5,
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.black38,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Interventions à contrôler\n\n",
                                            style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: Colors.black38,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            '${chiffres["nb_intervention_a_controler"]}',
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
                              ),
                              /*Container(
                    width: largeur / 3.5,
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.black38,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              typeUser=="Client"?"Interventions Controléés\n":"Interventions Controléés\n\n",
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.black38,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              '0',
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
                  ),*/
                              Expanded(
                                flex: 5,
                                child: Container(
                                  //width: largeur / 3.5,
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.black38,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Interventions contrôlées\n\n",
                                            style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: Colors.black38,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            '${chiffres['nb_intervention_controles']}',
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
                              )
                            ],
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: largeur / 17),
                    child: Row(
                      children: [
                        Text(
                          typeUser != 'Contrôleur'
                              ? '\nInterventions actuelles (${actualInterventions.length})'
                              : '\nContrôles actuels (${actualInterventions.length})',
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: user['type_user'] == 2
                        ? largeur / 3 + 139
                        : largeur / 3 + 87,
                    child: actualInterventions.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: largeur * 3 / 4,
                                child: InkWell(
                                  onTap: () {
                                    detailIntervention(
                                        context, largeur, hauteur,
                                        intervention:
                                            actualInterventions[index]);
                                  },
                                  child: Container(
                                    child: ActualInterventionWidget(
                                      intervention: actualInterventions[index],
                                      canNote: actualInterventions[index]['client_id']==user['id'],
                                    ),
                                  ),
                                ),
                                height: largeur / 3,
                              );
                            },
                            itemCount: actualInterventions.length,
                            scrollDirection: Axis.horizontal,
                          )
                        : NoData(typeUser != 'Contrôleur'
                            ? 'Aucune intervention en cours.'
                            : 'Aucun contrôle.'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: largeur / 17),
                    child: Row(
                      children: [
                        Text(
                          typeUser != 'Contrôleur'
                              ? 'Interventions à venir (${comingInterventions.length})'
                              : 'Contrôles à venir (${comingInterventions.length})',
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
                  SizedBox(
                    height: user['type_user'] == 2
                        ? largeur / 3 + 100
                        : largeur / 3 + 50,
                    child: comingInterventions.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Container(
                                  width: largeur*4/5,
                                  child: InkWell(
                                    onTap: (){
                                      detailIntervention(
                                          context, largeur, hauteur,
                                          intervention:
                                          comingInterventions[index]);
                                    },
                                    child: ComingInterventionWidget(
                                      intervention: comingInterventions[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: comingInterventions.length,
                            scrollDirection: Axis.horizontal,
                          )
                        : NoData(typeUser != 'Contrôleur'
                            ? 'Aucune intervention à venir.'
                            : 'Aucun contrôle à venir.'),
                  ),
                ],
              ),
            )
          : Container(
              child: LoadingData(45),
              height: hauteur * 2 / 3,
            ),
    );
  }
}
