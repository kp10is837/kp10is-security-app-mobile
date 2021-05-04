import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:negomer_mobile/poste_detail_screen.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/widget/loading_data.dart';
import 'package:negomer_mobile/widget/no_data.dart';
import 'package:negomer_mobile/widget/poste_widget.dart';

class PostesScreen extends StatefulWidget{
  PostesScreen();

  @override
  _PosteScreenState createState() => _PosteScreenState();
}

class _PosteScreenState extends State<PostesScreen> {
  var postes = [];
  bool loading = true;
  var user = ApiService.user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('start');
    loadData();

  }

  loadData() async{
    //loading = true;
    var responseQuery = await ApiService.getData('${ApiService.postes}/${user['token']}');
    print('responseQuery.body ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {
        postes = (jsonResp['postes']);
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: loading?
      Container(
        height: MediaQuery.of(context).size.height/1.5,
        child: LoadingData(45),
      ):
      postes.length > 0?
      SizedBox(
        height: MediaQuery.of(context).size.height/1.5,
        child: ListView.builder(itemBuilder: (context, index){
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 7.0
            ),
            child: InkWell(
              child: PosteWidget(
                poste: postes[index],
              ),
              onTap: (){
                Navigator.push(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                      return new PosteDetalScreen(
                        poste: postes[index],
                      );
                    }));
              },
            ),
          );
        },
          itemCount: postes.length,),
      ):
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30
        ),
          height: MediaQuery.of(context).size.height/1.5,
          child: NoData("Vous ne disposez d'aucun poste d'intervention."),
      )
    );
  }
}