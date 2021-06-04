// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:negomer_mobile/monCodeQR.dart';
import 'package:negomer_mobile/pointage_screen.dart';
import 'package:negomer_mobile/scanner.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/contants.dart';
import 'package:negomer_mobile/utils/preferences.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'Acceuil.dart';
import 'AcceuilProfile.dart';
import 'connexion.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:intl/intl.dart';
import 'alarm_screen.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:rxdart/subjects.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:android_intent/android_intent.dart';
import 'package:uni_links/uni_links.dart';
import 'package:android_intent/flag.dart';

import 'package:flutter/foundation.dart';
import 'package:overlay_support/overlay_support.dart';

checkAlarms(context) {
  var user = ApiService.user;
  String token = '';

  //Les interventions du jour
  print('notif init');
  var todayInterventions = [];
  DateTime actual = DateTime.now();
  String heureActuelle = DateFormat.Hm().format(actual);
  /*String retrieve = await SharedPreferencesHelper.getValue('today_interventions');
  Future<String> interventionsPreferences =
  SharedPreferencesHelper.getValue("today_interventions");
  /*AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 11,
          channelKey: 'basic_channel',
          title: 'Simple Notification',
          body: 'Simple body'
      )
  );*/
  print('notif started');
  //SharedPreferencesHelper.setValue("alarm_fired", "1");
  interventionsPreferences.then((String value) {
    if(!Utils.empty(value)){
      todayInterventions = json.decode(retrieve);
      print('interventions stored $todayInterventions');
      for(var element in todayInterventions) {
        DateTime dt_autorise = DateTime.parse('${element['date_intervention']} ${element['heure_debut']}');
        DateTime dt_actuel = DateTime.parse('${element['date_intervention']} $heureActuelle');
        print('checkingggggggggggggg');
        if(dt_autorise.minute != dt_actuel.minute && dt_autorise.hour != dt_actuel.hour){
          //SharedPreferencesHelper.setValue("alarm_fired", "1");
          print('Alarm OK');
          //Bringtoforeground.bringAppToForeground();
          /*AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 10,
                  channelKey: 'ringtone_channel',
                  title: 'Simple Notification',
                  body: 'Simple body'
              )
          );*/
          break;
          //return;
          //await LaunchApp.isAppInstalled(androidPackageName: 'com.kp10.apps.negomer', iosUrlScheme: 'pulsesecure://');
          //return runApp(new MaterialApp(home: new AlarmScreen()));
        }
      }
    }
    else{
      todayInterventions = [];
    }
  });

  print('interventions stored $todayInterventions');
  */
  //Vérifier si minuit ont sonné pour récupérer les interventions de la journée
  DateTime dt_minuit = DateTime.parse('2021-05-06 00:00');
  DateTime dt_actuel = DateTime.parse('2021-05-06 $heureActuelle');
  //if(dt_minuit.minute == dt_actuel.minute && dt_minuit.hour == dt_actuel.hour){
  //if(dt_minuit.hour < dt_actuel.hour){
    Future<String> tokenPreferences = SharedPreferencesHelper.getValue("token");
    tokenPreferences.then((String value) async {
      token = value;
      print('Getting interventions...');
      String url = '${ApiService.toDayInterventions}?token=$token';
      print('user token $token');
      var responseQuery = await ApiService.getData(url);
      print('daily.body ${responseQuery.body}');
      if (responseQuery.statusCode == 200) {
        var jsonResp = json.decode(responseQuery.body);
        var actualInterventions = [];
        actualInterventions = jsonResp['interventions'];
        //print('actualInterventions $actualInterventions');
        String string = '';
        if(!Utils.empty(actualInterventions)){
          if(actualInterventions.length > 0){
            string = jsonEncode(actualInterventions);
          }
        }
        print('stringInts $string');
        Utils.storePreference(string, "today_interventions");

        final AndroidIntent intent = AndroidIntent(
          action: 'io.flutter.app.FlutterApplication',
          data: 'package:com.kp10.apps.negomer',
        );
        //intent.launch();
      }
    });

  //}
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    //print("Native called background task: $backgroundTask"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

//void main() => runApp(MyApp());

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

String selectedNotificationPayload;
final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

void main() async{
  runApp(MyApp());
  /*const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectedNotificationPayload = payload;
        selectNotificationSubject.add(payload);
      });*/

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
        NotificationChannel(
            channelKey: 'badge_channel',
            channelName: 'Badge indicator notifications',
            channelDescription: 'Notification channel to activate badge indicator',
            channelShowBadge: true,
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.yellow),
        NotificationChannel(
            channelKey: 'ringtone_channel',
            channelName: 'Ringtone Channel',
            channelDescription: 'Channel with default ringtone',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            defaultRingtoneType: DefaultRingtoneType.Ringtone),
      ]
  );
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  /*Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  Workmanager().registerPeriodicTask(
      "2",
      "simplePeriodicTask",
      // When no frequency is provided the default 15 minutes is set.
      // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
      frequency: Duration(hours: 15),
  );*/
  print('app started');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.blue,
            buttonColor: Color(0xFF5038D5),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            )),
        debugShowCheckedModeBanner: false,
        //initialRoute: '/acceuil',
        home: SplashScreen(),
        routes: {
          '/connexion': (context) => Connexion(),
          '/acceuil': (context) => Acceuil(),
          '/acceuilProfile': (context) => AcceuilProfile(),
          '/scanner': (context) => Scanner(),
          '/moncodeqr': (context) => MonCodeQR(),
        },
      )
    );
  }
}

class SplashScreen extends StatefulWidget {
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  String _platformVersion = 'Unknown';
  String alarmFired = '0';
  Timer _everySecond;

  Uri _initialUri;
  Uri _latestUri;
  Object _err;

  StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    this.initPlatformState();
    _handleIncomingLinks();
    //sheduleNotification();
    Utils.getAuthUser();
    // ignore: invalid_use_of_visible_for_testing_member
    //SharedPreferences.setMockInitialValues({});
    String af = '0';
    _everySecond = Timer.periodic(Duration(seconds: 10), (t) {
      //print('app running');
    });
    Timer(Duration(seconds: 5), () {
      //Utils.getAuthUser();
      _checkData();
    });
  }

  void _handleIncomingLinks() {

    print('got uri: null');
    //if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    //}
  }

  sheduleNotification() async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        '11', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    final int helloAlarmID = 1;
    // Platform messages may fail, so we use a try/catch PlatformException.
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(const Duration(seconds: 20), helloAlarmID, checkAlarms);
    try {
      Timer.periodic(Duration(seconds: 10), (t) {
        //Bringtoforeground.bringAppToForeground();

      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Constants.myPrimary,
                  Constants.myPrimary2,
                  Constants.myPrimary3,
                  Constants.myPrimary4,
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: AssetImageMap(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 60.0),
                        ),
                        Text(
                          Constants.appDescription,
                          style: GoogleFonts.lato(
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }

  _checkData() async {
    Future<int> stepAuth = SharedPreferencesHelper.getIntValue("step_auth");
    stepAuth.then((int value) async {
      if (value == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Acceuil();
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return AcceuilProfile();
        }));
        /* Future<int> isAdmin = SharedPreferencesHelper.getIntValue("is_admin");
        isAdmin.then((int value) async {
          print("Boom" + value.toString());
          if (value == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return AdminDashboardHomeScreen(0);
            }));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return DashboardHomeScreen();
            }));
          }
        });*/
      }
    });
  }
}

class AssetImageMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage imageAsset = AssetImage('assets/acceuilImage.png');
    Image image = Image(
      image: imageAsset,
      width: 60.0,
      height: 60.0,
    );
    return image;
  }
}
