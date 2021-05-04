import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:negomer_mobile/success_page.dart';
import 'package:negomer_mobile/error_page.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:geolocator/geolocator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:toast/toast.dart';

class ScanCode extends StatefulWidget {
  @override
  _ScanCodeState createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
  Uint8List bytes = Uint8List(0);
  var agent;
  bool loading = false;
  var user = ApiService.user;

  late TextEditingController _inputController;
  late TextEditingController _outputController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  initState() {
    super.initState();
    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
    _getCurrentLocation();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var _myPosition;

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _myPosition = position;
        print('position ${_myPosition.latitude.toString()}');
        // print('My position LAT ${position.latitude.toString()} LONG ${position.longitude}');
      });
    }).catchError((e) {
      print(e);
    });
  }

  checkAgent(code) async {
    //_getCurrentLocation();
    String url = '${ApiService.checkUser}';
    print('user token ${user['token']}');
    var responseQuery = await ApiService.postData(context,url,{
      'user_token':'${user['token']}',
      'agent_token':'$code',
      'observation':'',
      'latitude': '${_myPosition.latitude.toString()}',
      'longitude': '${_myPosition.longitude.toString()}',
      'position_exacte':''
    });
    print('responseQuery.body ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {
        agent = (jsonResp['agent']);
        print('agent $agent');
        loading = false;
      });
      if(jsonResp['status'] == 'OK'){
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
              return new SuccessPage("${jsonResp['message']}");
            }));
      }else{
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
              return new ErrorPage("${jsonResp['message']}");
            }));
      }

      //Toast.show("Agent contôlé avec succès", context, duration: Toast.LENGTH_LONG*3, gravity:  Toast.TOP);
      //detailAgent(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.width,code, agent: agent);
    }
  }

  getAgent(code) async {
    //_getCurrentLocation();
    String url = '${ApiService.getUser}';
    print('user token ${user['token']}');
    var responseQuery = await ApiService.postData(context,url,{
      'user_token':'${user['token']}',
      'agent_token':'$code',
      'observation':'',
      'latitude': !Utils.empty(_myPosition)?'${_myPosition.latitude.toString()}':'0',
      'longitude': !Utils.empty(_myPosition)?'${_myPosition.longitude.toString()}':'0',
    });
    print('responseQuery.body ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {
        agent = (jsonResp['agent']);
        print('agent $agent');
        loading = false;
      });
      detailAgent(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.width, code, agent: agent);
    }
  }

  detailAgent(context, largeur, hauteur, code, {agent}) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      dialogType: DialogType.NO_HEADER,
      body: Container(
        child: Card(
          elevation: 0,
          shadowColor: Colors.black38,
          child: Container(
              width: largeur,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              padding: EdgeInsets.symmetric(
                  vertical: hauteur / 60, horizontal: largeur / 25),
              child: Column(
                children: [
                  Container(
                    child: Text('Résultat du scan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        child: Text(
                          !Utils.empty(agent)?"Les informations contenues dans le QR CODE correspondent à ${agent['first_name']} ${agent['last_name']} ":
                          "Les informations contenues dans le QR CODE ne correspondent pas à nos enregistrements",
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        padding: EdgeInsets.only(
                            bottom: 20
                        ),
                      ),
                      AnimatedButton(
                          text: !Utils.empty(agent)?'Confirmer la présence':'Fermer',
                          pressEvent: () {
                            if(Utils.empty(agent))
                              Navigator.pop(context);
                            else{
                              Navigator.pop(context);
                              checkAgent(code);
                            }
                          })
                    ],
                  ),
                ],
              )),
        ),
      ),
    )..show();
  }

  Widget _buttonGroup(largeur, hauteur) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: InkWell(
            onTap: _scan,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset("assets/scanCode.jpg",
                        height: hauteur / 5, fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _scan() async {
    await Permission.camera.request();
    await Permission.storage.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      this._outputController.text = barcode;
      getAgent(barcode);
    }
  }

  /*Future _scan() async {
    var codeSanner = await BarcodeScanner.scan();
  }*/

  Future _scanPhoto() async {
    await Permission.storage.request();
    String barcode = await scanner.scanPhoto();
    this._outputController.text = barcode;
  }

  Future _scanPath(String path) async {
    await Permission.storage.request();
    String barcode = await scanner.scanPath(path);
    this._outputController.text = barcode;
  }

  Future _scanBytes() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      File file =
          ImagePicker.platform.pickImage(source: ImageSource.camera) as File;
      if (file == null) return;
      Uint8List bytes = file.readAsBytesSync();
      String barcode = await scanner.scanBytes(bytes);
      this._outputController.text = barcode;
    }
  }

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.blue[900],
        title: Text("Contrôle d'un agent"),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: hauteur / 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: hauteur / 60, horizontal: largeur / 15),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                /*Center(
                    child: Text(
                      'Controlleur',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.indigo[600],
                        fontWeight: FontWeight.w300,
                      ),
                    )),*/
                Center(
                    child: Text(
                      'Scanner un code QR',
                      style: GoogleFonts.lato(
                        fontSize: 22,
                        color: Colors.black54,
                        fontWeight: FontWeight.w900,
                      ),
                    )),
                SizedBox(height: 50),
                this._buttonGroup(largeur, hauteur),
                SizedBox(height: 30),
                /*TextField(
                  controller: this._outputController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.pages),
                    helperText: 'Veuillez scanner un code.',
                    helperStyle: GoogleFonts.lato(color: Colors.orange),
                    hintText: 'Resultat du code scanné.',
                    hintStyle: GoogleFonts.lato(fontSize: 15),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                  ),
                ),*/
                SizedBox(height: 20),
                /*RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  color: Colors.indigo[900],
                  child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      children: [
                        Text(
                          'Contrôler',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    if(Utils.empty(_outputController.text)){
                      return;
                    }
                    checkAgent(_outputController.text);
                  },
                ),*/
              ],
            ),
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => _scanBytes(),
        tooltip: 'Take a Photo',
        child: const Icon(Icons.camera_alt),
      ),*/
    );
  }
}
