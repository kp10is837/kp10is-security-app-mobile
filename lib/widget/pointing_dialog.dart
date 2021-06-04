
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

pointingDialog(context){
  return AwesomeDialog(
    context: context,
    animType: AnimType.SCALE,
    headerAnimationLoop: false,
    dialogType: DialogType.NO_HEADER,
    body: Container(
      child: Text('Zutt.....'),
    )
  );
}