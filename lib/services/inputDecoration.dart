import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

inputDecoration(label, largeur) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.black12,
    hintText: '${label}',
    hintStyle: GoogleFonts.lato(fontSize: 15),
    contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(17),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(15),
    ),
  );
}
