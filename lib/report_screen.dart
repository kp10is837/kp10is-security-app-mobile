import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:negomer_mobile/agent/AcceuilProfileAgent.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:toast/toast.dart';

class ReportScreen extends StatefulWidget{
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>{
  var user = ApiService.user;
  final messageController = TextEditingController();

  getView(){
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 7
      ),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300]
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10
            ),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 7,
              obscureText: false,
              controller: messageController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Votre message",
                hintStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }

  report() async{
    String url = '${ApiService.report}';
    var responseQuery = await ApiService.postData(context,url,{
      'token':'${user['token']}',
      'urgence':'${messageController.text}',
    });
    print('rating ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {

      });
      Toast.show("${jsonResp['message']}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
      /*Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new AcceuilProfile();

        }));*/
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Signaler une urgence'),
        brightness: Brightness.dark,
      ),
      body: getView(),
      bottomSheet: Container(
          margin: EdgeInsets.all(15.0),
          height: 55,
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width,
            child: RaisedButton(
              onPressed: () {
                if(Utils.empty(messageController.text)){
                  Toast.show("Merci de renseigner votre message", context, duration: Toast.LENGTH_LONG*3, gravity: Toast.TOP);
                  return;
                }
                report();
              },
              color: Colors.blue[900],
              textColor: Colors.white,
              child: Text("Signaler"),
            ),
          )
      ),
    );
  }
}