import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/services/detailIntervention.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/widget/intervention_widget.dart';
import 'package:negomer_mobile/widget/loading_data.dart';
import 'package:negomer_mobile/widget/no_data.dart';

class Historique extends StatefulWidget {
  Historique();

  @override
  _HistoriqueState createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {

  var interventions = [];
  bool loading = true;
  var user = ApiService.user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async{
    //loading = true;
    String url = '';
    url = '${ApiService.interventionOfPoste}?token=${user['token']}&historique=1';
    var responseQuery = await ApiService.getData(url);
    print('responseQuery.body ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {
        interventions = (jsonResp['interventions']);
        loading = false;
      });
    }
  }

  getView(){
    var intText = 'intervention';
    if(interventions.length>1)
      intText = 'interventions';
    if(user['type_user']==2){
      intText += ' controlée';
      if(interventions.length>1)
        intText += 's';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        interventions.length>1?
        Text('${interventions.length} $intText', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),):
        Container(),
        SingleChildScrollView(
          child: loading?
          Container(
            child: LoadingData(45),
            height: MediaQuery.of(context).size.height-250,
          ):
          interventions.length>0?
          SizedBox(
            height: MediaQuery.of(context).size.height-230,
            child: ListView.builder(itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                  detailIntervention(
                      context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height,
                      intervention: interventions[index]);
                },
                child: InterventionWidget(
                  intervention: interventions[index],
                  canNote: interventions[index]['client_id']==user['id'],
                ),
              );
            },
              itemCount: interventions.length,),
          ):
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30
            ),
            child: NoData("Historique vide"),
            height: MediaQuery.of(context).size.height-250,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(7),
      child: getView(),
    );
  }
}
