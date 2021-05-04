import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  static String appName = "Negomer";
  static String token = "Negomer@2021";
  static String appDescription = "Bienvenue sur NEGOMER !";

  static String host = "http://192.168.1.147/negomer/negomer_sarl/public/api/";
  // static String host = "https://negomer.mcttogo.com";
  //static String host = "https://testapp.negomer-groupe.com";

  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.blueGrey[900]!;
  static Color darkAccent = Colors.white;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;
  static Color myPrimary = Color(0xff7986CB);
  static Color myPrimary2 = Color(0xff5C6BC0);
  static Color myPrimary3 = Color(0xff3F51B5);
  static Color myPrimary4 = Color(0xff3949AB);
  static Color myAccent = Color(0xffEFC03D);

  static const String POPPINS = "Poppins";
  static const String OPEN_SANS = "OpenSans";
  static const String NEXT = "Suivant";
  static const String PREVIOUS = "Précédent";
  static const String FINISH = "Commencer";
  static const String SLIDER_HEADING_1 = "Cashentraide!";
  static const String SLIDER_HEADING_2 = "Facile à Utiliser!";
  static const String SLIDER_HEADING_3 = "Faites un prêt rapidement";
  static const String SLIDER_DESC1 =
      "Nous octroyons un dépannage ou aide financière aux salariés en cas de difficultés à boucler les fins du mois.";
  static const String SLIDER_DESC2 =
      "Nous vous offrons la meilleure expérience utilisateur afin de vous faciliter vos opérations.";
  static const String SLIDER_DESC3 =
      "Après validation de votre prêt, vous percevez votre argent dans un délai de 30 minutes maximum.";
}

// Colors
const Color kBlue = Color(0xFF3287B6);
const Color kLightBlue = Color(0xFF086EB6);
const Color kDarkBlue = Color(0xFF1046B3);
const Color kWhite = Color(0xFFFFFFFF);
const Color kGrey = Color(0xFFF4F5F7);
const Color kBlack = Color(0xFF2D3243);

// Padding
const double kPaddingS = 8.0;
const double kPaddingM = 16.0;
const double kPaddingL = 32.0;

// Spacing
const double kSpaceS = 8.0;
const double kSpaceM = 16.0;

// Animation
const Duration kButtonAnimationDuration = Duration(milliseconds: 600);
const Duration kCardAnimationDuration = Duration(milliseconds: 400);
const Duration kRippleAnimationDuration = Duration(milliseconds: 400);
const Duration kLoginAnimationDuration = Duration(milliseconds: 1500);

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: kBlue,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
