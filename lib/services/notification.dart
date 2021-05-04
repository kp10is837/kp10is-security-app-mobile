import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:negomer_mobile/utils/utils.dart';

notificationWidget(context, largeur, hauteur, {intervention}) {

  final Set<Marker> _markers = {};
  _markers.add(Marker(
    markerId: MarkerId('${intervention['client']['id']}'),
    position: !Utils.empty(intervention['client']['latitude'])?LatLng(double.parse('${intervention['client']['latitude']}'), double.parse('${intervention['client']['longitude']}')):LatLng(0,0),
    infoWindow: InfoWindow(
      title: intervention['client']['raison_sociale'],
      snippet: intervention['client']['quartier'],
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue
    ),
  ));
  Completer<GoogleMapController> _controller = Completer();
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
            child: Column(
              children: [
                !Utils.empty(intervention['client']['latitude'])?
                Container(
                  height: 120,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller){
                      _controller.complete(controller);
                      _markers.add(Marker(
                        markerId: MarkerId('${intervention['client']['id']}'),
                        position: LatLng(double.parse('${intervention['client']['latitude']}'), double.parse('${intervention['client']['longitude']}')),
                        infoWindow: InfoWindow(
                          title: intervention['client']['raison_sociale'],
                          snippet: intervention['client']['quartier'],
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue
                        ),
                      ));
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse('${intervention['client']['latitude']}'), double.parse('${intervention['client']['longitude']}')),
                      zoom: 9.5,
                    ),
                    mapType: MapType.normal,
                    markers: _markers,
                    myLocationEnabled: true,

                    myLocationButtonEnabled: true,
                    //polylines: polylnes,
                  ),
                ):
                Container(),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Poste d'intervention",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            !Utils.empty(intervention['client']['last_name'])?'${intervention['client']['first_name']} ${intervention['client']['last_name']}':
                            '${intervention['client']['raison_sociale']}',
                            style: GoogleFonts.lato(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Début",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            '${intervention['heure_debut']}\n',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fin",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            '${intervention['heure_fin']}\n',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Date:",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 10
                            ),
                          ),
                          Text(
                            "${Utils.formatDateTime(intervention['date_intervention'], "full_fr")}",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 10
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Intervenant:",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 10
                            ),
                          ),
                          Text(
                            "${intervention['agent']['first_name']} ${intervention['agent']['last_name']}",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 10
                        ),
                      ),
                      Text(
                        "Description",
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        !Utils.empty(intervention['description'])?"${intervention['description']}\n":"",
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Commentaire",
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        !Utils.empty(intervention['commentaire'])?"${intervention['commentaire']}\n":"",
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      AnimatedButton(
                          text: 'Fermer',
                          pressEvent: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                )
              ],
            )),
      ),
    ),
  )..show();
}
