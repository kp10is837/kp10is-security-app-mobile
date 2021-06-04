import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/success_page.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:negomer_mobile/widget/app_text_field.dart';
import 'package:negomer_mobile/widget/loading_data.dart';
import 'package:toast/toast.dart';

class SettingsScreen extends StatefulWidget{
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{
  TextEditingController timeController = TextEditingController();
  var user = ApiService.user;
  var loading = true;

  @override
  initState(){
    super.initState();
    this.loadData();
  }

  loadData() async{
    String url = '${ApiService.getUserInfo}?token=${user['token']}';
    var responseQuery = await ApiService.getData(url);
    print('settings ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      if(!Utils.empty(jsonResp['user']['delai'])){
        setState(() {
          timeController.text = '${jsonResp['user']['delai']}';
        });
      }
      setState(() {
        loading = false;
      });
      //Toast.show("${jsonResp['message']}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
    }
  }

  saveParam() async{
    if(Utils.empty(timeController.text)){
      Toast.show("Merci de renseigner le nombre de minutes !", context, duration: Toast.LENGTH_LONG*3, gravity: Toast.TOP);
      return;
    }
    if(int.parse(timeController.text)<15){
      Toast.show("Merci de renseigner un nombre supérieur ou égal à 15 !", context, duration: Toast.LENGTH_LONG*3, gravity: Toast.TOP);
      return;
    }
    String url = '${ApiService.setParam}';
    var responseQuery = await ApiService.postData(context,url,{
      'token':'${user['token']}',
      'delai':'${timeController.text}',
    });
    //print('settings ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {

      });
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessPage('${jsonResp['message']}')),
      ).then((value) => {
        //initPointing()
      });
      //Toast.show("${jsonResp['message']}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
    }
  }

  getView(){
    return SizedBox(
      child: !loading?ListView(
        children: [
          AppTextField(
            controller: timeController,
            textInputType: TextInputType.number,
            label: 'Recevoir l\'alerte combien de minutes avant le début de l\'intervention ?',
            hint: 'Nombre de minutes',
          ),
          Container(
              margin: EdgeInsets.only(
                  top: 50,
                  bottom: 20
              ),
              height: 55,
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: () {
                    saveParam();
                  },
                  color: Colors.blue[900],
                  textColor: Colors.white,
                  child: Text("Valider"),
                ),
              )
          )
        ],
      ):
      LoadingData(45),
      height: MediaQuery.of(context).size.height-100,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
        backgroundColor: Colors.blue[900],
        brightness: Brightness.dark,
      ),
      body: Padding(
        child: getView(),
        padding: EdgeInsets.symmetric(
            horizontal: 16
        ),
      ),
    );
  }
}