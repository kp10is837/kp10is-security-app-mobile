import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ScanCode extends StatefulWidget {
  @override
  _ScanCodeState createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
  Uint8List bytes = Uint8List(0);

  late TextEditingController _inputController;
  late TextEditingController _outputController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  initState() {
    super.initState();
    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                              'Megomer App',
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
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: hauteur / 60, horizontal: largeur / 15),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Text(
                        'Controlleur',
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          color: Colors.indigo[600],
                          fontWeight: FontWeight.w300,
                        ),
                      )),
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
                      TextField(
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
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
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
                                'Scanner',
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          _scan();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () => _scanBytes(),
          tooltip: 'Take a Photo',
          child: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}
