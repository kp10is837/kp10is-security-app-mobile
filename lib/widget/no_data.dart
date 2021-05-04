import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class NoData extends StatelessWidget {
  String title;

  NoData(this.title);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 20),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.lato(
              fontStyle: FontStyle.normal,
              fontSize: 24,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
