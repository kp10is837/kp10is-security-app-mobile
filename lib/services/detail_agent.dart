import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:negomer_mobile/utils/utils.dart';

detailAgent(context, largeur, hauteur, {agent}) {
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
                  child: Text('Résultat du contrôle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      child: Text(
                        !Utils.empty(agent)?"Agent ${agent['first_name']} ${agent['last_name']} contrôlé avec succès":
                        "Les informations contenues dans le QR CODE ne correspondent pas à nos enregistrement",
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
                        text: 'Fermer',
                        pressEvent: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              ],
            )),
      ),
    ),
  )..show();
}
