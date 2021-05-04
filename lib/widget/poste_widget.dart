
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PosteWidget extends StatefulWidget{
  var poste;
  PosteWidget({this.poste});

  @override
  _PosteWidgetState createState() => _PosteWidgetState(poste: this.poste);



}

class _PosteWidgetState extends State<PosteWidget>{
  var poste;
  _PosteWidgetState({this.poste});
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    addMakers();
  }

  void addMakers(){
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('${poste['id']}'),
        position: LatLng(double.parse('${poste['latitude']}'), double.parse('${poste['longitude']}')),
        infoWindow: InfoWindow(
          title: poste['raison_sociale'],
          snippet: poste['quartier'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var intText = 'intervention';
    if(poste['nbInterventions']>1)
      intText = 'interventions';
    return Container(
      height: MediaQuery.of(context).size.width * 35 / 100,
      width: double.infinity,
      //padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('${poste['raison_sociale']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  Text('${poste['matricule']}', style: TextStyle(fontSize: 15, color: Colors.grey),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.grey,size: 20,),
                      Text('${poste['quartier']}', style: TextStyle(fontSize: 15, color: Colors.grey),),
                    ],
                  ),
                  Text('${poste['nbInterventions']} $intText')
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse('${poste['latitude']}'), double.parse('${poste['longitude']}')),
                  zoom: 9.5,
                ),
                mapType: MapType.normal,
                markers: _markers,
                myLocationEnabled: true,

                myLocationButtonEnabled: true,
                //polylines: polylnes,
              ),
            ),
            flex: 4,
          )
        ],
      ),
    );
  }
}