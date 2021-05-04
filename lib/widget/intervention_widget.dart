import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/utils.dart';
import '../services/detailIntervention.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:toast/toast.dart';

class InterventionWidget extends StatefulWidget {
  var intervention;
  bool canNote = false;

  @override
  _InterventionWidgetState createState() => _InterventionWidgetState(
      intervention: this.intervention, canNote: this.canNote);

  InterventionWidget({this.intervention, this.canNote = false});
}

class _InterventionWidgetState extends State<InterventionWidget> {
  var intervention;
  var user = ApiService.user;
  bool canNote = false;
  _InterventionWidgetState({this.intervention, this.canNote = false});

  void commenter() async {
    _displayDialog(context);
  }

  rateAgent(double rate, String comment) async {
    if (Utils.empty(comment) && Utils.empty(rate)) {
      Toast.show("Veuillez donner votre avis ou votre note.", context,
          duration: Toast.LENGTH_LONG * 3, gravity: Toast.TOP);
      return;
    }
    String url = '${ApiService.noteAgent}';
    var responseQuery = await ApiService.postData(context, url, {
      'token': '${user['token']}',
      'note': '$rate',
      'commentaire': '$comment',
      'intervention_id': '${intervention["id"]}'
    });
    print('rating ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if (responseQuery.statusCode == 200) {
      setState(() {});
      Toast.show("Votre avis a été pris en compte.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      setState(() {
        intervention['note'] = jsonResp['intervention']['note'];
      });
      Navigator.of(context).pop();
    }
  }

  TextEditingController _textFieldController = TextEditingController();
  _displayDialog(BuildContext context) async {
    _textFieldController.text = !Utils.empty(intervention['commentaire'])
        ? '${intervention['commentaire']}'
        : '';
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
                  TextField(
                    controller: _textFieldController,
                    maxLines: 3,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Votre avis",
                      hintStyle: GoogleFonts.lato(
                          fontStyle: FontStyle.normal,
                          color: Colors.blueGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: RatingBar.builder(
                      initialRating: !Utils.empty(intervention['note'])
                          ? double.parse('${intervention['note']}')
                          : 0.0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 20,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      onRatingUpdate: (rating) {
                        rate = rating;
                      },
                    ),
                  ),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () {
                        if (Utils.empty(intervention['note'])) {
                          intervention['note'] = 0;
                        }
                        double r = rate == 0
                            ? double.parse('${intervention['note']}')
                            : rate;
                        rateAgent(r, _textFieldController.text);
                        //rateCommerce(rate, _textFieldController.text);
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

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    // TODO: implement build
    return InkWell(
      onTap: () {
        detailIntervention(context, largeur, hauteur,
            intervention: this.intervention);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: Card(
          elevation: 10,
          shadowColor: Colors.black38,
          child: Container(
              width: largeur,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              padding: EdgeInsets.symmetric(
                  vertical: hauteur / 60, horizontal: largeur / 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                              //color: Colors.white,
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
                              //color: Colors.white,
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(25)),
                                )
                              : Container(),
                          Icon(
                            Icons.date_range,
                            color: Colors.grey,
                            size: 22,
                          ),
                          Text(
                            '${Utils.formatDateTime(intervention['date_intervention'], "full_fr")}',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              //color: Colors.white,
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
                                //color: Colors.white,
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
                                //color: Colors.white,
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
                              color: Colors.grey,
                              size: 22,
                            ),
                            Text(
                              '${intervention['client']['quartier']}',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                //color: Colors.white,
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
                              //color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            '${intervention['heure_debut']}',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              //color: Colors.white,
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
                              //color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            '${intervention['heure_fin']}',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              //color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingBar.builder(
                        initialRating: !Utils.empty(intervention['note'])
                            ? double.parse('${intervention['note']}')
                            : 0,
                        minRating: 1,
                        itemSize: 20,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      canNote
                          ? InkWell(
                              onTap: () {
                                commenter();
                              },
                              child: Text(
                                "Noter l'agent",
                                style: GoogleFonts.lato(
                                    color: Colors.blue[900],
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400),
                              ))
                          : Container(),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
