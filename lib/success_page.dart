import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessPage extends StatelessWidget {
  String content;
  var operationType;
  var subscriptionId;
  var param;
  SuccessPage(this.content,
      {this.operationType, this.subscriptionId, this.param});
  @override
  Widget build(BuildContext context) {
    var btnLabel = 'Terminer';
    if (operationType != null) {
      btnLabel = 'Continuer';
    }
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 3)),
              child: Icon(
                Icons.check,
                color: Colors.blue[900],
                size: 70,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 20
              ),
            ),
            Text(
              'Opération réussie.',
              style: TextStyle(fontSize: 20, color: Colors.blue[900]),
            ),
            Text(
              content,
              style: TextStyle(fontSize: 15),
            ),
            RaisedButton(
              color: Colors.indigo[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "TERMINER",
                style: GoogleFonts.lato(
                  color: Colors.white,
                ),
              ),
              //padding: EdgeInsets.all(hauteur / 43),
              onPressed: () {
                Navigator.pop(context);
              },
            )
            /*Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: AppButton(
                label: '$btnLabel',
                bgColor: AppColors.red,
                textColor: Colors.white,
                onTap: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()),  (Route<dynamic> route) => false);
                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
