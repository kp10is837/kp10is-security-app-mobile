// @dart=2.9
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:negomer_mobile/monCodeQR.dart';
import 'package:negomer_mobile/scanner.dart';
import 'package:negomer_mobile/utils/contants.dart';
import 'package:negomer_mobile/utils/preferences.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'Acceuil.dart';
import 'AcceuilProfile.dart';
import 'connexion.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonColor: Color(0xFF5038D5),
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          )),
      debugShowCheckedModeBanner: false,
      //initialRoute: '/acceuil',
      home: SplashScreen(),
      routes: {
        '/connexion': (context) => Connexion(),
        '/acceuil': (context) => Acceuil(),
        '/acceuilProfile': (context) => AcceuilProfile(),
        '/scanner': (context) => Scanner(),
        '/moncodeqr': (context) => MonCodeQR(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Utils.getAuthUser();
    // ignore: invalid_use_of_visible_for_testing_member
    //SharedPreferences.setMockInitialValues({});
    Timer(Duration(seconds: 5), () {
      //Utils.getAuthUser();
      _checkData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Constants.myPrimary,
                  Constants.myPrimary2,
                  Constants.myPrimary3,
                  Constants.myPrimary4,
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: AssetImageMap(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 60.0),
                        ),
                        Text(
                          Constants.appDescription,
                          style: GoogleFonts.lato(
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }

  _checkData() async {
    Future<int> stepAuth = SharedPreferencesHelper.getIntValue("step_auth");
    stepAuth.then((int value) async {
      if (value == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Acceuil();
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return AcceuilProfile();
        }));
        /* Future<int> isAdmin = SharedPreferencesHelper.getIntValue("is_admin");
        isAdmin.then((int value) async {
          print("Boom" + value.toString());
          if (value == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return AdminDashboardHomeScreen(0);
            }));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return DashboardHomeScreen();
            }));
          }
        });*/
      }
    });
  }
}

class AssetImageMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage imageAsset = AssetImage('assets/acceuilImage.png');
    Image image = Image(
      image: imageAsset,
      width: 60.0,
      height: 60.0,
    );
    return image;
  }
}
