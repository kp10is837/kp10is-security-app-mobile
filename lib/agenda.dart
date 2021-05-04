import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:negomer_mobile/widget/loading_data.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/agenda_detail.dart';

/// The hove page which hosts the calendar
class Agenda extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const Agenda();

  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  late List<Meeting> meetings;
  var user = ApiService.user;
  var comingInterventions = [];
  bool loading = true;

  @override
  initState() {
    super.initState();
    this.loadData();
  }

  loadData() async{
    String url = '${ApiService.agenda}?token=${user['token']}';
    print('user token ${user['token']}');
    var responseQuery = await ApiService.getData(url);
    print('responseQuery.body ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if(responseQuery.statusCode==200) {
      setState(() {
        comingInterventions = (jsonResp['coming_interventions']);
        print('coming $comingInterventions');
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;

    return !loading?
    Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: largeur / 17),
              child: Row(
                children: [
                  Text(
                    '\nMon agenda\n',
                    style: GoogleFonts.lato(
                      fontSize: 17,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: largeur / 25),
              child: Card(
                elevation: 10,
                shadowColor: Colors.black26,
                child: SfCalendar(
                  onTap: (CalendarTapDetails details) {
                    if (details.targetElement == CalendarElement.appointment) {
                      print("pressed");
                    }
                    DateTime date = details.date;
                    print(date);
                    dynamic appointments = details.appointments;
                    print(appointments[0].eventName);
                    CalendarElement view = details.targetElement;
                    print(view);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AgendaDetail(
                      date: '${details.date.year}-${details.date.month}-${details.date.day}',
                    )),);
                  },
                  minDate: DateTime.now(),
                  firstDayOfWeek: 1,
                  view: CalendarView.month,
                  //view: CalendarView.workWeek,
                  timeSlotViewSettings: TimeSlotViewSettings(
                      startHour: 9,
                      endHour: 16,
                      nonWorkingDays: <int>[DateTime.friday, DateTime.saturday]),
                  headerHeight: 50,
                  dataSource: MeetingDataSource(_getDataSource()),
                  viewHeaderStyle: ViewHeaderStyle(
                    backgroundColor: Colors.blue[50],
                    dayTextStyle: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w900),
                  ),
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                  headerStyle: CalendarHeaderStyle(
                    backgroundColor: Colors.indigo,
                    textStyle: GoogleFonts.lato(fontSize: 14, color: Colors.white),
                  ),
                  viewHeaderHeight: 25,
                  monthViewSettings: MonthViewSettings(
                      appointmentDisplayMode:
                      MonthAppointmentDisplayMode.indicator),
                ),
              ),
            ),
            /*Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: largeur / 17),
          child: Row(
            children: [
              Text(
                '\nIntervention à venir',
                style: GoogleFonts.lato(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: hauteur / 80, horizontal: largeur / 25),
          child: Card(
            elevation: 10,
            shadowColor: Colors.black38,
            child: Container(
                width: largeur,
                decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                padding: EdgeInsets.symmetric(
                    vertical: hauteur / 60, horizontal: largeur / 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date d'intervention\n",
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              '03 avril 2021',
                              style: GoogleFonts.lato(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.white70,
                              size: 22,
                            ),
                            Text(
                              'Agbalépédogan,',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\nDébut",
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              '18h : 45m',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\nFin",
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              '02h : 45m',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),*/
          ],
        )):
    Container(
      child: LoadingData(45),
      height: hauteur-200,
    );
  }

  List<Meeting> _getDataSource() {
    meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    comingInterventions.forEach((element) {
      final DateTime date = DateTime.parse('${element['date_intervention']}');
      final DateTime start = DateTime(date.year, date.month, date.day, 9, 0, 0);
      final DateTime end = DateTime(date.year, date.month, date.day, 9, 0, 0);
      String title = !Utils.empty(element['description'])?element['description']:'';
      meetings.add(Meeting(
          '$title', start, end, const Color(0xFF0F8644), false));
    });
    return meetings;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
