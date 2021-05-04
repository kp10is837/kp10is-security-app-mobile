import 'dart:convert';
import 'package:negomer_mobile/services/api_service.dart';
import 'preferences.dart';
import 'package:intl/intl.dart';

class Utils{
  static storePreference(String data, String prefName) async {
    SharedPreferencesHelper.setValue(prefName, data);
  }

  static empty(data){
    return data=='' || data==null || data=='null' || data=='00:00' || data == 0 || data == '0';
  }

  static getAuthUser() async {
    String retrieve = await SharedPreferencesHelper.getValue('user');
    if(!empty(retrieve)){
      ApiService.user = json.decode(retrieve);
    }
    else{
      ApiService.user = null;
    }
    print('user stored ${ApiService.user}');
  }

  static formatDateTime(dateString, format){
    if(format=='full_fr'){
      var date = DateTime.parse(dateString);
      int month = date.month;
      return '${date.day} ${months[month-1]} ${date.year}';
    }
    var formatter = new DateFormat(format);
    var dateConvert = DateTime.parse(dateString);
    return formatter.format(dateConvert);
  }

  static const months = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre'
  ];
}