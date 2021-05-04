import 'dart:io';

import 'package:flutter/material.dart';
import 'package:negomer_mobile/Menu.dart';
import 'package:negomer_mobile/page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/preferences.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:negomer_mobile/services/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:async';
import 'dart:convert';

class AcceuilProfile extends StatefulWidget {
  int selectedIndex = 0;

  AcceuilProfile({this.selectedIndex = 0});

  @override
  _AcceuilProfileState createState() =>
      _AcceuilProfileState(selectedIndex = this.selectedIndex);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class _AcceuilProfileState extends State<AcceuilProfile> {
  @override
  int _selectedIndex = 0;
  String telephone = "";
  String firstName = "";
  String lastName = "";
  String login = "";
  String email = "";
  String typeUser = "";

  _AcceuilProfileState(this._selectedIndex);

  Future<String> telephonePreferences =
      SharedPreferencesHelper.getValue("telephone");
  Future<int> typeUserPreferences =
      SharedPreferencesHelper.getIntValue("type_user");
  Future<String> firstNamePreferences =
      SharedPreferencesHelper.getValue("first_name");
  Future<String> lastNamePreferences =
      SharedPreferencesHelper.getValue("last_name");
  Future<String> loginPreferences = SharedPreferencesHelper.getValue("login");
  Future<String> emailPreferences = SharedPreferencesHelper.getValue("email");
  var user = ApiService.user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.getAuthUser();
    print('type useeeeee ${user['type_user']}');
    setState(() {
      if ('${user['type_user']}' == '1') {
        typeUser = "Agent";
      } else if ('${user['type_user']}' == '2') {
        typeUser = "Contrôleur";
      } else if ('${user['type_user']}' == '3') {
        typeUser = "Client";
      }
    });
    typeUserPreferences.then((int value) async {});
    telephonePreferences.then((String value) async {
      setState(() {
        telephone = value;
      });
    });
    emailPreferences.then((String value) async {
      setState(() {
        email = value;
      });
    });
    loginPreferences.then((String value) async {
      setState(() {
        login = value;
      });
    });
    firstNamePreferences.then((String value) async {
      setState(() {
        firstName = value;
      });
    });
    lastNamePreferences.then((String value) async {
      setState(() {
        lastName = value;
      });
    });
    this.initialise();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initialise() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    print('pusher_id');
    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('On message ${json.decode(message.data['intervention'])}');
      var intervention = json.decode(message.data['intervention']);
      //print('On message length ${json.decode(message.data[0])}');
      notificationWidget(context, MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
          intervention: intervention);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('On message ${json.decode(message.data['intervention'])}');
      var intervention = json.decode(message.data['intervention']);
      //print('On message length ${json.decode(message.data[0])}');
      notificationWidget(context, MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
          intervention: intervention);
    });

    String? token = '';
    await FirebaseMessaging.instance.getToken().then((value) {
      print('pusher_id $value');
      token = value;
    });

    final response = await ApiService.postDataWithoutShowingDialog(
        context, ApiService.saveDevice, {
      'p_token': !Utils.empty(user['token']) ? user['token'] : '',
      'pusher_id': token,
      'user_id': '${user['token']}',
      'platform': Platform.isIOS ? 'ios' : 'android',
      'provider': 'FIREBASE'
    });

    print('responseQuery.body ${response.body}');
  }

  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
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
            ),
            Container(child: page(_selectedIndex, typeUser == "Client" && Utils.empty(user['parent']) ? 1 : 0))
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[900],
        items: typeUser == "Client" && Utils.empty(user['parent'])
            ? <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Acceuil',
                  backgroundColor: Colors.blue[900],
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Postes',
                  backgroundColor: Colors.blue[900],
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Agenda',
                  backgroundColor: Colors.blue[900],
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'Historique',
                  backgroundColor: Colors.blue[900],
                ),
              ]
            : [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Acceuil',
                  backgroundColor: Colors.blue[900],
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Agenda',
                  backgroundColor: Colors.indigo[900],
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'Historique',
                  backgroundColor: Colors.blue[900],
                ),
              ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
