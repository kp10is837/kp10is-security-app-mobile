import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:negomer_mobile/services/api_service.dart';
import 'package:negomer_mobile/utils/utils.dart';
import 'package:negomer_mobile/widget/intervention_widget.dart';
import 'package:negomer_mobile/widget/loading_data.dart';
import 'package:negomer_mobile/widget/no_data.dart';

class AgendaDetail extends StatefulWidget {
  var date;
  AgendaDetail({this.date});

  @override
  _AgendaDetailState createState() => _AgendaDetailState(date: this.date);
}

class _AgendaDetailState extends State<AgendaDetail> {
  var date;
  var dates = [];
  var interventions = [];
  var user = ApiService.user;
  int selectedIndex = 0;
  bool loading = true;
  bool loading2 = false;
  _AgendaDetailState({this.date});

  @override
  initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    String url =
        '${ApiService.usercomingDate}?token=${user['token']}&date=$date';
    print('user token ${user['token']}');
    var responseQuery = await ApiService.getData(url);
    print('responseQuery.body ${responseQuery.body}');
    var jsonResp = json.decode(responseQuery.body);
    if (responseQuery.statusCode == 200) {
      setState(() {
        interventions = (jsonResp['coming_interventions']);
        dates = (jsonResp['dates']);
        print('comingssss $interventions');
        if (interventions.length > 0) {
          setState(() {
            interventionsToShow = interventions[0]['interventions'];
          });
        }
        loading = false;
      });
    }
  }

  var interventionsToShow = [];
  getView() {
    return Container(
      child: !loading
          ? Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              loading2 = true;
                              selectedIndex = index;
                            });
                            Timer(Duration(seconds: 1), () {
                              setState(() {
                                interventionsToShow = [];
                                interventionsToShow =
                                    interventions[index]['interventions'];
                                print('date $interventionsToShow');
                                loading2 = false;
                              });
                            });
                            setState(() {});
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                  color: selectedIndex == index
                                      ? Colors.red
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                      color: selectedIndex != index
                                          ? Colors.red
                                          : Colors.white)),
                              height: 50,
                              //width: 100,
                              child: Center(
                                child: Text(
                                  '${Utils.formatDateTime(dates[index], 'full_fr')}',
                                  style: TextStyle(
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Colors.blue[900],
                                      fontSize: 15),
                                ),
                              )),
                        ),
                      );
                    },
                    itemCount: dates.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Divider(),
                SingleChildScrollView(
                  child: loading2
                      ? LoadingData(45)
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 170,
                            child: interventionsToShow.length > 0
                                ? ListView.builder(
                                    itemBuilder: (context, index) {
                                      return InterventionWidget(
                                        intervention:
                                            interventionsToShow[index],
                                        canNote: interventionsToShow[index]
                                                ['client_id'] ==
                                            user['id'],
                                      );
                                    },
                                    itemCount: interventionsToShow.length,
                                  )
                                : Container(
                                    child: NoData(
                                        'Aucune intervention à cette date'),
                                  ),
                          ),
                        ),
                )
              ],
            )
          : LoadingData(45),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Mon agenda'),
          backgroundColor: Colors.blue[900],
          brightness: Brightness.dark,
        ),
        body: getView());
  }
}
