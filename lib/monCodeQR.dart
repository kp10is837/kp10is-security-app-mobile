import 'package:flutter/material.dart';
import 'package:negomer_mobile/Menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class MonCodeQR extends StatefulWidget {
  MonCodeQR();

  @override
  _MonCodeQRState createState() => _MonCodeQRState();
}

class _MonCodeQRState extends State<MonCodeQR> {
  Uint8List bytes = Uint8List(0);
  late TextEditingController _inputController;
  late TextEditingController _outputController;

  @override
  initState() {
    super.initState();
    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
    _generateBarCode("${ApiService.user['token']}");
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(largeur / 10),
                        bottomRight: Radius.circular(largeur / 10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: hauteur / 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: hauteur / 50, horizontal: largeur / 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.menu_sharp,
                              color: Colors.white70,
                              size: 30,
                            ),
                            onPressed: () {
                              _scaffoldKey.currentState!.openDrawer();
                            },
                          ),
                          Text(
                            'NEGOMER',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              color: Colors.white70,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: hauteur / 20,
              ),
              _qrCodeWidget(this.bytes, context, hauteur, largeur),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[900],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acceuil',
            backgroundColor: Colors.blue[900],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarms),
            label: 'Agenda',
            backgroundColor: Colors.indigo[600],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
            backgroundColor: Colors.black54,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _qrCodeWidget(
      Uint8List bytes, BuildContext context, hauteur, largeur) {
    // _generateBarCode("pascal");
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black26,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.verified_user, size: 18, color: Colors.blue[100]),
                  Text('  Mon code QR',
                      style:
                          GoogleFonts.lato(fontSize: 15, color: Colors.white)),
                  Spacer(),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 190,
                    child: bytes.isEmpty
                        ? Center(
                            child: Text('Pas de code ... ',
                                style: GoogleFonts.lato(color: Colors.black38)),
                          )
                        : Image.memory(bytes),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: hauteur / 40,
            ),
            Divider(height: 2, color: Colors.black26),
            SizedBox(
              height: hauteur / 40,
            )
          ],
        ),
      ),
    );
  }

  Future _scan() async {
    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      this._outputController.text = barcode;
    }
  }

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
}
