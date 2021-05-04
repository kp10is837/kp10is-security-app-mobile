import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:toast/toast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ActualInterventionWidget extends StatefulWidget{
  var intervention;
  bool canNote = false;
  ActualInterventionWidget({this.intervention, this.canNote=false});

  @override
  _ActualInterventionWidgetState createState() => _ActualInterventionWidgetState(intervention: this.intervention, canNote: this.canNote);
}

class _ActualInterventionWidgetState extends State<ActualInterventionWidget>{
  var intervention;
  var user = ApiService.user;
  bool canNote = false;

  _ActualInterventionWidgetState({this.intervention, this.canNote=false});

  void commenter() async {
    _displayDialog(context);
  }

  rateAgent(double rate, String comment) async{
    if(Utils.empty(comment) && Utils.empty(rate)){
      Toast.show("Veuillez donner votre avis ou votre note", context, duration: Toast.LENGTH_LONG*3, gravity:  Toast.TOP);
      return;
    }
    String url = '${ApiService.noteAgent}';
    var responseQuery = await ApiService.postData(context,url,{
      'token':'${user['token']}',
      'note':'$rate',
      'commentaire':'$comment',
      'intervention_id':'${intervention["id"]}'
    });
    print('rating ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {

      });
      Toast.show("Votre avis a été pris en compte", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
      setState(() {
        intervention['note'] = jsonResp['intervention']['note'];
      });
      Navigator.of(context).pop();
    }
  }

  TextEditingController _textFieldController = TextEditingController();
  _displayDialog(BuildContext context) async {
    _textFieldController.text=!Utils.empty(intervention['commentaire'])?'${intervention['commentaire']}':'';
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
                    decoration: InputDecoration(hintText: "Votre avis"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 30),
                    child: RatingBar.builder(
                      initialRating: !Utils.empty(intervention['note'])?double.parse('${intervention['note']}'):0.0,
                      direction: Axis.horizontal,
                      itemSize: 25,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      onRatingUpdate: (rating) {
                        rate=rating;
                      },
                    ),
                  ),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () {
                        if(Utils.empty(intervention['note'])){
                          intervention['note'] = 0;
                        }
                        double r = rate==0?double.parse('${intervention['note']}'):rate;
                        rateAgent(r, _textFieldController.text);
                        //rateCommerce(rate, _textFieldController.text);
                      },
                      color: Colors.blue[900],
                      textColor: Colors.white,
                      child: Text("Valider"),
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
    // TODO: implement build
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 4, horizontal: 10),
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
                vertical: 10, horizontal: 10),
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
                          user['type_user']==3?"Intervenant":user['type_user']==1?"Poste d'intervention":"Agent",
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          user['type_user']!=1?'${intervention['agent']['first_name']} ${intervention['agent']['last_name']}':
                          !Utils.empty(intervention['client']['last_name'])?'${intervention['client']['first_name']} ${intervention['client']['last_name']}':
                          '${intervention['client']['raison_sociale']}',
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
                        intervention['controlled']==true?
                        Container(
                          child: Text('Contrôlé', style: TextStyle(color: Colors.red),),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)
                          ),
                        ):
                        Container(),
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
                user['type_user']==2?
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 15
                  ),
                ):
                Container(),
                user['type_user']==2?
                Column(
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
                      !Utils.empty(intervention['client']['last_name'])?'${intervention['client']['first_name']} ${intervention['client']['last_name']}':
                      '${intervention['client']['raison_sociale']}',
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ):
                Container(),
                !Utils.empty(intervention['client']['quartier'])?
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 15
                  ),
                ):Container(),
                !Utils.empty(intervention['client']['quartier'])?
                Row(
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
                ):Container(),
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
                ),
                Divider(color: Colors.grey[100],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingBar.builder(
                      initialRating: !Utils.empty(intervention['note'])?double.parse('${intervention['note']}'):0,
                      minRating: 1,
                      itemSize: 20,
                      direction: Axis.horizontal,
                      allowHalfRating: false,ignoreGestures: true,
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
                    canNote?
                    InkWell(
                        onTap: (){
                          commenter();
                        },
                        child: Text("Noter l'agent", style: TextStyle(color: Colors.grey[100], fontSize: 18))
                    ):
                    Container(),
                  ],
                )
              ],
            )),
      ),
    );
  }

}