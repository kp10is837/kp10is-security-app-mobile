import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:negomer_mobile/connexion.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/preferences.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:negomer_mobile/widget/app_text_field.dart';
import 'package:toast/toast.dart';

class ChangePasswordScreen extends StatefulWidget{
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>{
  final TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var user = ApiService.user;

  getView(){
    return SizedBox(
      child: ListView(
        children: [
          AppTextField(
            controller: oldPasswordController,
            textInputType: TextInputType.text,
            label: 'Ancien mot de passe',
            hint: 'Votre ancien mot de passe',
            obscureText: true,
          ),
          AppTextField(
            controller: newPasswordController,
            textInputType: TextInputType.text,
            label: 'Nouveau mot de passe',
            hint: 'Votre nouveau mot de passe',
            obscureText: true,
          ),
          AppTextField(
            controller: confirmPasswordController,
            textInputType: TextInputType.text,
            label: 'Confirmation',
            hint: 'Confirmez votre nouveau mot de passe',
            obscureText: true,
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
                    changePassword();
                  },
                  color: Colors.blue[900],
                  textColor: Colors.white,
                  child: Text("Modifier"),
                ),
              )
          )
        ],
      ),
      height: MediaQuery.of(context).size.height-100,
    );
  }

  _quit() async {
    SharedPreferencesHelper.setIntValue("step_auth", 0);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Connexion()),
            (Route<dynamic> route) => false);
    /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Connexion();
    }));*/
  }

  changePassword() async{
    print('pwd ${oldPasswordController.text}');
    if(Utils.empty(oldPasswordController.text)){
      Toast.show("Merci de renseigner votre ancien mot de passe !", context, duration: Toast.LENGTH_LONG*3, gravity: Toast.TOP);
      return;
    }
    if(Utils.empty(newPasswordController.text)){
      Toast.show("Merci de renseigner votre nouveau mot de passe !", context, duration: Toast.LENGTH_LONG*3, gravity: Toast.TOP);
      return;
    }
    if(newPasswordController.text.length < 6){
      Toast.show("Le mot de passe doit contenir au moins 6 caractères !", context, duration: Toast.LENGTH_LONG*3, gravity: Toast.TOP);
      return;
    }
    if(newPasswordController.text != confirmPasswordController.text){
      Toast.show("Le mot de passe de confirmation ne correspond pas !", context, duration: Toast.LENGTH_LONG*3, gravity: Toast.TOP);
      return;
    }
    String url = '${ApiService.changePassword}';
    var responseQuery = await ApiService.postData(context,url,{
      'token':'${user['token']}',
      'old_password':'${oldPasswordController.text}',
      'password':'${newPasswordController.text}',
    });
    print('rating ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {

      });
      Toast.show("${jsonResp['message']}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
      if(jsonResp['error']==false){
        _quit();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Modifez votre mot de passe'),
        backgroundColor: Colors.blue[900],
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