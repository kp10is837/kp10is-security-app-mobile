
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';

class ApiService{
  /*static final apiHost = 'http://192.168.1.132/tourneur-admin/public/api/v1/';*/
  //static final imagesHost = 'http://192.168.1.132/tourneur-admin/public/uploads/';
  /*static final apiHost = 'http://laravel.mamgabon.com/public/api/v1/';
  static final imagesHost = 'http://laravel.mamgabon.com/public/uploads/';*/

  //static final apiHost = 'http://192.168.1.147/negomer/negomer_sarl/public/api/';
  //static final apiHost = 'http://192.168.1.147/nego/public/api/';
  //static final apiHost = 'https://testapp.negomer-groupe.com/api/';
  //static final apiHost = 'https://securite.negomer-groupe.com/api/';
  static final apiHost = 'https://securite.kp10is.com/api/';
  //static final apiHost = 'http://192.168.1.69/nego/public/api/';
  //static final apiHost = 'http://192.168.1.147/nego/public/api/';
  static final imagesHost = 'http://192.168.1.147/biziye/public/uploads/';

  static String postes = "client/postes";
  static String interventionOfPoste = "postes/interventions";
  static String userDashboard = "user/dashboard";
  static String usercomingDate= "user/four-daycoming-intervention";
  static String checkUser= "controle";
  static String getUser= "get-agent";
  static String noteAgent= "client/note";
  static String agenda= "user/agenda";
  static String saveDevice= "user/save-device";
  static String report= "report";
  static String changePassword= "auth/change-password";
  static String initPointing= "init-pointage";
  static String pointing= "pointage";
  static String toDayInterventions= "today-interventions";
  static String autoControle= "auto-controle";
  static String canPointe= "can-pointe";
  static String setParam= "set-param";
  static String getUserInfo= "get-user";
  static String checkPointingState= "check-pointing-state";

  /*static final apiHost = 'http://biziye.jmmgroup.fr/api/';
  static final imagesHost = 'http://biziye.jmmgroup.fr/uploads/';
  static final uploadHost = 'http://biziye.jmmgroup.fr/';*/

  static var user;
  static var entreprise;
  static var particulier;

  static postData(context, String url, data) async{
    var pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
      message: 'Patientez S.V.P....',
    );
    if(context!=null){
      pr.show();
    }
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //var deviceToken = prefs.getString('DEVICE_TOKEN');
    //var accessToken = user!=null?user.accessToken:'';
    var response = await http.post(Uri.parse(apiHost+url), body: data);
    pr.hide();
    return response;
  }

  static postDataWithoutShowingDialog(context, String url, data) async{
    var response = await http.post(Uri.parse(apiHost+url), body: data);
    return response;
  }

  static getData(String url) async {
    //var accessToken = user!=null?user.accessToken:'';
    var response = await http.get(Uri.parse(apiHost+url));
    return response;
  }
}

