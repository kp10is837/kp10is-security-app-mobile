import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/widget/intervention_widget.dart';
import 'package:negomer_mobile/widget/loading_data.dart';
import 'package:negomer_mobile/widget/no_data.dart';
class PosteDetalScreen extends StatefulWidget{
    var poste;
    PosteDetalScreen({this.poste});

    @override
    _PosteDetalScreenState createState() => _PosteDetalScreenState(poste: this.poste);
}

class _PosteDetalScreenState extends State<PosteDetalScreen>{
  var poste;
  var interventions = [];
  _PosteDetalScreenState({this.poste});
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async{
    //loading = true;
    var responseQuery = await ApiService.getData('${ApiService.interventionOfPoste}?poste_token=${poste['token']}');
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
    if(poste['nbInterventions']>1)
      intText = 'interventions';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        interventions.length>0?
        Text('${poste['nbInterventions']} $intText', style: TextStyle(color: Colors.grey, fontSize: 20),):
        Container(),
        SingleChildScrollView(
          child: loading?
          Container(
            child: LoadingData(45),
            height: MediaQuery.of(context).size.height-150,
          ):
          interventions.length>0?
          SizedBox(
            height: MediaQuery.of(context).size.height-150,
            child: ListView.builder(itemBuilder: (context, index){
              return InterventionWidget(
                intervention: interventions[index],
              );
            },
              itemCount: interventions.length,),
          ):
          Container(
            height:  MediaQuery.of(context).size.height-150,
            child: NoData("Aucune intervention pour ce poste"),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.blue[900],
        title: Text('${poste['raison_sociale']}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: getView(),
      ),
    );
  }
}