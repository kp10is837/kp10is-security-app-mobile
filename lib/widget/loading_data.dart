import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingData extends StatelessWidget{
  double size;

  LoadingData(this.size);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: SpinKitThreeBounce(
        color: Colors.blue[900],
        size: size,
      ),
    );
  }
}