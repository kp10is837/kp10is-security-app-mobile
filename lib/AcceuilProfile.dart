
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:negomer_mobile/Menu.dart';
import 'package:negomer_mobile/main.dart';
import 'package:negomer_mobile/page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/pointage_screen.dart';
import 'package:negomer_mobile/scanCode.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/preferences.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:negomer_mobile/services/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:animated_background/animated_background.dart';

import 'package:flutter/services.dart';
import 'package:toast/toast.dart' as MyToast;
import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:workmanager/workmanager.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:negomer_mobile/alert_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wakelock/wakelock.dart';


class AcceuilProfile extends StatefulWidget {
  int selectedIndex = 0;

  AcceuilProfile({this.selectedIndex = 0});

  @override
  _AcceuilProfileState createState() =>
      _AcceuilProfileState(selectedIndex = this.selectedIndex);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

ringPhone(){
  FlutterRingtonePlayer.play(
    android: AndroidSounds.ringtone,
    ios: IosSounds.glass,
    looping: true, // Android only - API >= 28
    volume: 0.1, // Android only - API >= 28
    asAlarm: true, //
  );// Android only - all APIs
}


var preferences;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    preferences = await StreamingSharedPreferences.instance;
    print("Native called background task"); //simpleTask will be emitted here.
    DateTime actual = DateTime.now();
    String heureActuelle = DateFormat.Hm().format(actual);
    Future<int> typeUserPreferences =
    SharedPreferencesHelper.getIntValue("type_user");
    String typeUser = "";
    /*typeUserPreferences.then((int value) async {
      if (value == 1) {
        typeUser = "Agent";
      } else if (value == 2) {
        typeUser = "Contrôleur";
      } else if (value == 3) {
        typeUser = "Client";
      }
    });*/
    var user;
    String retrieve = await SharedPreferencesHelper.getValue('user');
    if(retrieve != ''){
      user = json.decode(retrieve);
    }
    else{
      user = null;
    }
    var responseQuery = await ApiService.getData('${ApiService.checkPointingState}?token=${user['token']}&actual_time=$heureActuelle');
    print('responseQuery.body ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      if(jsonResp['status']=='OK'){
        if(jsonResp['controle'] == true){
          ringPhone();
          preferences.setString("controle", "1");
          preferences.setString("alerte_id", "${jsonResp['alerte']['id']}");
          SharedPreferencesHelper.setValue(
              "controle", "1");
          Wakelock.enable();
          Bringtoforeground.bringAppToForeground();
          /*Navigator.push(
            getco,
            MaterialPageRoute(builder: (context) => AlertScreen(
              date: '02-06-2021',
              heure: '06:30',
              alarmFired: '2',
            )),
          );*/
          /*showSimpleNotification(
            Text("Subscribe to FilledStacks"),
            background: Colors.purple,
          );*/
        }
        if(jsonResp['remember'] == true){
          SharedPreferencesHelper.setValue(
              "remember", "1");
          Bringtoforeground.bringAppToForeground();
          //ringPhone();
        }
        /*if(jsonResp['end_pointe'] == true){
          SharedPreferencesHelper.setValue(
              "end_pointe", "1");
        }*/
      }
    }
    return Future.value(true);
  });
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

class _AcceuilProfileState extends State<AcceuilProfile> with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  int _selectedIndex = 0;
  String telephone = "";
  String firstName = "";
  String lastName = "";
  String login = "";
  String email = "";
  String typeUser = "";
  bool canPointe = false;

  _AcceuilProfileState(this._selectedIndex);

  Future<String> telephonePreferences =
      SharedPreferencesHelper.getValue("telephone");
  Future<int> typeUserPreferences =
      SharedPreferencesHelper.getIntValue("type_user");
  Future<String> firstNamePreferences =
      SharedPreferencesHelper.getValue("first_name");
  Future<String> lastNamePreferences =
      SharedPreferencesHelper.getValue("last_name");
  Future<String> loginPreferences = SharedPreferencesHelper.getValue("login");
  Future<String> emailPreferences = SharedPreferencesHelper.getValue("email");
  var user = ApiService.user;
  String alarmFired = '0';
  Timer? _everySecond;
  String date = '07 Mai 2021';
  String heure = '17:48';
  String interventionId = '';
  String alerteId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    this.initPlatformState();
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    );
    Workmanager().registerPeriodicTask(
      "3",
      "Periodic task",
      initialDelay: Duration(seconds: 10),
    );
    Utils.getAuthUser();
    localNotification();
    setState(() {
      if ('${user['type_user']}' == '1') {
        typeUser = "Agent";
      } else if ('${user['type_user']}' == '2') {
        typeUser = "Contrôleur";
      } else if ('${user['type_user']}' == '3') {
        typeUser = "Client";
      }
    });
    _getCurrentLocation();
    print('type useeeeee ${user['type_user']}');
    checkCanPointe();
    //initAlarm();
    print('apppppp running');

    checkChanges();


    this.initialise();
    //await ProcessSignal.sigterm.watch().first;

    var initializationSettingsAndroid =
    AndroidInitializationSettings('flutter_devs');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings();

    /*flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);*/

    /*showSimpleNotification(
      Text("Subscribe to FilledStacks"),
      background: Colors.purple,
    );*/

    //notif();
  }

  notif()async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeating channel id',
        'repeating channel name', 'repeating description');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  checkChanges() async{
    WidgetsFlutterBinding.ensureInitialized();
    preferences = await StreamingSharedPreferences.instance;
    //pour les contrôles
    Preference<String> counter = preferences.getString('controle', defaultValue: "0");
    counter.listen((value) {
      print('listen  $value');
      if(value == '1'){
        ringPhone();
        setState(() {
          alarmFired = '2';
          heure = DateFormat.Hm().format(DateTime.now());
        });

        Preference<String> alerteIdPref = preferences.getString('alerte_id', defaultValue: "0");
        alerteIdPref.listen((value) {
          print('listen alerte id  $value');
          setState(() {
            heure = DateFormat.Hm().format(DateTime.now());
            alerteId = value;
          });
        });
      }
    });



    //pour les rappels
    Preference<String> rappel = preferences.getString('remember', defaultValue: "0");
    rappel.listen((value) {
      print('listen remember $value');
      if(value == '1'){
        ringPhone();
        setState(() {
          alarmFired = '1';
          heure = DateFormat.Hm().format(DateTime.now());
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState? _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    checkChanges();
    setState(() { _notification = state; });
  }

  checkCanPointe() async{
    String url = '${ApiService.canPointe}?token=${user['token']}';
    //print('user token ${user['token']}');
    var responseQuery = await ApiService.getData(url);
    print('can pointe ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if (responseQuery.statusCode == 200) {
      if(jsonResp['status']=='OK'){
        setState(() {
          canPointe = true;
        });
      }
      else{
        canPointe = false;
      }
    }
  }

  ringPhone(){
    FlutterRingtonePlayer.play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.glass,
        looping: true, // Android only - API >= 28
        volume: 0.1, // Android only - API >= 28
        asAlarm: true, //
    );// Android only - all APIs
  }

  Future _showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Notification',
      'Flutter is awesome',
      platformChannelSpecifics,
      payload: 'This is notification detail Text...',
    );
  }

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  onBackgroundMessage(RemoteMessage message) async {
    //String encodedUrl = message.data[''];
    //debugPrint("onBackgroundMessage called $encodedUrl");
    print('app available');
    await _showNotification(flutterLocalNotificationsPlugin);

  }

  Future onSelectNotification(String? payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Your Notification Detail"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  void localNotification() {
    print('local notif');
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

  }

  Future<void> initPlatformState() async {
    String platformVersion;
    final int helloAlarmID = 2;
    // Platform messages may fail, so we use a try/catch PlatformException.
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(const Duration(seconds: 2), helloAlarmID, checkAlarms);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  getFired() async{
    String retrieve = await SharedPreferencesHelper.getValue("alarm_fired");
    print('fann $retrieve');
    setState(() {
      //alarmFired = retrieve;
    });
  }

  initAlarm() async{
    final int helloAlarmID = 0;
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(const Duration(seconds: 1), helloAlarmID, checkAlarms);
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    //await Firebase.initializeApp();
    ringPhone();
    Bringtoforeground.bringAppToForeground();
    ringPhone();
    var intervention = json.decode(message.data['intervention']);
    //print('On message length ${json.decode(message.data[0])}');
    notificationWidget(context, MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
        intervention: intervention);

    print('Handling a background message ${message.messageId}');
  }

  void checkAlarms() {
    /*DateTime actual = DateTime.now();
    String heureActuelle = DateFormat.Hm().format(actual);
    DateTime dt_autorise = DateTime.parse('2021-05-05 09:10');
    DateTime dt_actuel = DateTime.parse('2021-05-05 $heureActuelle');
    print('checking');
    if(dt_autorise.minute == dt_actuel.minute){
      print('alarm ok $dt_actuel');
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new PointageScreen();
          }));
    }*/
    print('accueil alarm');
    //getFired();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initialise() async {
    await Firebase.initializeApp();
    //await Firebase.initializeApp();

    // Set the background messaging handler early on, as a named top-level function
    /*FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );*/

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print('On message length ${json.decode(message.data["alerte"])}');
      if(message.data['ntype']=="intervention"){
        var intervention = json.decode(message.data['intervention']);
        notificationWidget(context, MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
            intervention: intervention);
      }
      if(message.data['ntype']=="alerte" || message.data['ntype']=="rappel"){
        Wakelock.enable();
        Bringtoforeground.bringAppToForeground();
        //var alerte = message.data['alerte'];
        var intervention = json.decode(message.data['intervention']);
        ringPhone();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlertScreen(
            date: intervention['date_intervention'],
            heure: message.data['heure_controle'],
            alerte: message.data['ntype']=="alerte"?json.decode(message.data["alerte"]):null,
            alarmFired: message.data['ntype']=="alerte"?'2':'1',

          )),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('On message ${json.decode(message.data['intervention'])}');
      if(message.data['ntype']=="intervention"){
        var intervention = json.decode(message.data['intervention']);
        //print('On message length ${json.decode(message.data[0])}');
        notificationWidget(context, MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
            intervention: intervention);
      }
      if(message.data['ntype']=="alerte" || message.data['ntype']=="rappel"){
        Bringtoforeground.bringAppToForeground();
        //var alerte = message.data['alerte'];
        var intervention = json.decode(message.data['intervention']);
        ringPhone();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlertScreen(
            date: intervention['date_intervention'],
            heure: message.data['heure_controle'],
            alerte: message.data['ntype']=="alerte"?json.decode(message.data["alerte"]):null,
            alarmFired: message.data['ntype']=="alerte"?'2':'1',

          )),
        );
      }

    });

    String? token = '';
    await FirebaseMessaging.instance.getToken().then((value) {
      print('pusher_id $value');
      token = value;
    });

    final response = await ApiService.postDataWithoutShowingDialog(
        context, ApiService.saveDevice, {
      'p_token': !Utils.empty(user['token']) ? user['token'] : '',
      'pusher_id': token,
      'user_id': '${user['token']} ',
      'platform': Platform.isIOS ? 'ios' : 'android',
      'provider': 'FIREBASE'
    });

    print('responseQuery.body ${response.body}');
  }

  var _myPosition;
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _myPosition = position;
        print('position ${_myPosition.latitude.toString()}');
        // print('My position LAT ${position.latitude.toString()} LONG ${position.longitude}');
      });
    }).catchError((e) {
      print('error $e');
    });
  }

  Widget build(BuildContext context) {
    //getFired();
    print('Last notification: $_notification');
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;

    if(typeUser == "Agent"){
      int i=0;
      Timer.periodic(Duration(seconds: 25), (t) async {
        print('yessss');
        String controle = await SharedPreferencesHelper.getValue('controle');
        i++;

        var future = new Future.delayed(const Duration(seconds: 15), (){
          print('yessss $controle');
          /*if(controle == '1'){
            ringPhone();
            setState(() {
              alarmFired = '2';
              heure = DateFormat.Hm().format(DateTime.now());
            });
          }*/
        });

        String remember = await SharedPreferencesHelper.getValue('remember');
        if(remember == '1'){
          ringPhone();
          setState(() {
            alarmFired = '1';
            heure = DateFormat.Hm().format(DateTime.now());
          });
        }
      });
    }

    if(alarmFired == "0"){
      return  Scaffold(
        key: _scaffoldKey,
        drawer: Menu(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(largeur / 10),
                          bottomRight: Radius.circular(largeur / 10))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: hauteur / 15,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: hauteur / 50, horizontal: largeur / 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.menu_sharp,
                                color: Colors.white70,
                                size: 30,
                              ),
                              onPressed: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                            ),
                            Text(
                              'NEGOMER',
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(child: page(_selectedIndex, typeUser == "Client" && Utils.empty(user['parent']) ? 1 : 0))
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue[900],
          items: typeUser == "Client" && Utils.empty(user['parent'])
              ? <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Acceuil',
              backgroundColor: Colors.blue[900],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Postes',
              backgroundColor: Colors.blue[900],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Agenda',
              backgroundColor: Colors.blue[900],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Historique',
              backgroundColor: Colors.blue[900],
            ),
          ]
              : [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Acceuil',
              backgroundColor: Colors.blue[900],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Agenda',
              backgroundColor: Colors.indigo[900],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Historique',
              backgroundColor: Colors.blue[900],
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          onTap: _onItemTapped,
          showUnselectedLabels: true,
        ),
        floatingActionButton: canPointe&&typeUser == "Agent"?FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: PointageScreen(),
          backgroundColor: Colors.grey[50],
          elevation: 0,
        ):Container(),
      );
    }
    else{
      return new Scaffold(
        /*appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.blue[900],
          title: Text('Alerte'),
        ),*/
        body: Container(
          width: double.infinity,
          color: Colors.grey[700],
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white)
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25
                ),
                margin: EdgeInsets.only(
                    bottom: 10
                ),
                child: Text('$heure', style: TextStyle(fontSize: 25, color: Colors.white),),
              ),
              Container(
                child: Text('$date', style: TextStyle(fontSize: 17, color: Colors.white)),
                margin: EdgeInsets.only(
                    bottom: 25
                ),
              ),
              Container(
                child: Text(alarmFired=='2'?'Contrôle de présence':'Rappel',
                  style: TextStyle(color: Colors.white, fontSize: 25),),
                margin: EdgeInsets.only(
                    bottom: 25
                ),
              ),
              Container(
                child: Text(alarmFired=='1'?'Votre intervention débute bientôt':'',
                  style: TextStyle(color: Colors.white, fontSize: 15),),
                margin: EdgeInsets.only(
                    bottom: 25
                ),
              ),
              Container(
                child: Text(alarmFired=='2'?'Cliquez pour pointer':'Cliquez pour arrêter l\'alarme',
                  style: TextStyle(color: Colors.white, fontSize: 17),),
                margin: EdgeInsets.only(
                  bottom: 10
              ),
              ),
              InkWell(
                child: Container(
                  height: MediaQuery.of(context).size.width/4,
                  width: MediaQuery.of(context).size.width/4,
                  decoration: BoxDecoration(
                      //color: Colors.red[900],
                    border: Border.all(
                      color: Colors.white
                    ),
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: Icon(Icons.check, color: Colors.white,size: MediaQuery.of(context).size.width/6,),
                ),
                onTap: () async {
                  FlutterRingtonePlayer.stop();
                  if(alarmFired == '1'){
                    setState(() {
                      alarmFired = '0';
                    });
                    preferences.setString("remember", "0");
                    return;
                  }
                  preferences = await StreamingSharedPreferences.instance;
                  preferences.setString("controle", "0");
                  Utils.storePreference("0", "controle");
                  var url = '${ApiService.autoControle}';
                  DateTime actual = DateTime.now();
                  String heureActuelle = DateFormat.Hm().format(actual);
                  var data = {
                    'alerte_id': '$alerteId',
                    'heure_alerte': '$heure',
                    'heure_pointage': '$heureActuelle',
                    'token': '${user['token']}',
                    'latitude': '${_myPosition?.latitude.toString()}',
                    'longitude': '${_myPosition?.longitude.toString()}',
                  };
                  var responseQuery = await ApiService.postData(context,url,data);
                  print('reponse ${responseQuery.body}');
                  var jsonResp = json.decode(responseQuery.body);
                  if(responseQuery.statusCode==200) {
                    FlutterRingtonePlayer.stop();
                    setState(() {

                    });
                    if(jsonResp['status']=='OK'){
                      SharedPreferencesHelper.setValue("alarm_fired", "0");
                      setState(() {
                        alarmFired = '0';
                      });
                    }
                    MyToast.Toast.show("${jsonResp['message']}", context, gravity: MyToast.Toast.TOP, duration: MyToast.Toast.LENGTH_LONG);
                  }
                },
              )
            ],
          ),
        ),
      );
    }
  }
}
