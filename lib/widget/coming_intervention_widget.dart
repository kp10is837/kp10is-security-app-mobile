import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:negomer_mobile/services/api_service.dart';

class ComingInterventionWidget extends StatelessWidget {
  var intervention;
  ComingInterventionWidget({this.intervention});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    var user = ApiService.user;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black38,
        child: Container(
            width: largeur,
            decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                )),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['type_user'] == 3
                              ? "Intervenant"
                              : user['type_user'] == 1
                                  ? "Poste d'intervention"
                                  : "Agent",
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          user['type_user'] != 1
                              ? '${intervention['agent']['first_name']} ${intervention['agent']['last_name']}'
                              : !Utils.empty(
                                      intervention['client']['last_name'])
                                  ? '${intervention['client']['first_name']} ${intervention['client']['last_name']}'
                                  : '${intervention['client']['raison_sociale']}',
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        intervention['controlled'] == true
                            ? Container(
                                child: Text(
                                  'Contrôlé',
                                  style: TextStyle(color: Colors.red),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                              )
                            : Container(),
                        Icon(
                          Icons.date_range,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          '${Utils.formatDateTime(intervention['date_intervention'], "full_fr")}',
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
                user['type_user'] == 2
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 15),
                      )
                    : Container(),
                user['type_user'] == 2
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Poste d'intervention",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            !Utils.empty(intervention['client']['last_name'])
                                ? '${intervention['client']['first_name']} ${intervention['client']['last_name']}'
                                : '${intervention['client']['raison_sociale']}',
                            style: GoogleFonts.lato(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      )
                    : Container(),
                !Utils.empty(intervention['client']['quartier'])
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 15),
                      )
                    : Container(),
                !Utils.empty(intervention['client']['quartier'])
                    ? Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 22,
                          ),
                          Text(
                            '${intervention['client']['quartier']}',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                          )
                        ],
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\nDébut",
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          '${intervention["heure_debut"]}',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\nFin",
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          '${intervention["heure_fin"]}',
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
                )
              ],
            )),
      ),
    );
  }
}
