
import 'package:flutter/material.dart';
import 'package:negomer_mobile/utils/utils.dart';

class AppTextField  extends StatelessWidget {

  @required
  TextEditingController _controller = new TextEditingController();
  @required
  TextInputType? _textInputType;
  @required
  String? _hint;
  Widget? _lefIcon;
  Widget? _rightIcon;
  String? _label;
  bool _obscureText;

  AppTextField(
      {
        var controller,
        TextInputType? textInputType,
        Widget? lefIcon,
        Widget? rightIcon,
        String? label,
        String? hint,
        bool obscureText = false,
      }):    this._controller = controller, this._textInputType = textInputType, this._lefIcon = lefIcon, this._rightIcon = rightIcon,
              this._label = label, this._hint = hint, this._obscureText = obscureText;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        !Utils.empty(this._label)?
        Padding(
          padding: const EdgeInsets.only(top : 20),
          child: Text(
            '${this._label}',
            style: TextStyle(color: Colors.black, fontFamily: 'Raleway'),
          ),
        ) :  SizedBox(),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[300]
            ),
            margin:  !Utils.empty(this._label)? EdgeInsets.symmetric(vertical: 10.0) : EdgeInsets.only(top: 5.0, bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Stack(
              children: <Widget>[
                this._lefIcon!=null? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: this._lefIcon,
                  ),
                ) : SizedBox(),
                Container(
                  padding: EdgeInsets.only(left: this._lefIcon!=null? 30 : 0),
                  child: TextField(
                    obscureText: this._obscureText,
                    controller: this._controller,
                    keyboardType: this._textInputType,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: this._hint,
                      hintStyle: TextStyle(color: Colors.grey[600], fontFamily: 'TitilliumWeb'),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                !Utils.empty(this._rightIcon)? Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: this._rightIcon,
                  ),
                ) :  SizedBox(),
              ],
            )
        )
      ],
    );
  }
}