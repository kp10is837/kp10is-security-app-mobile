import 'package:flutter/material.dart';
import 'package:negomer_mobile/Menu.dart';
import 'package:negomer_mobile/Agent/pageAgent.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:negomer_mobile/utils/preferences.dart';

class AcceuilProfile extends StatefulWidget {
  AcceuilProfile();

  @override
  _AcceuilProfileState createState() => _AcceuilProfileState();
}

class _AcceuilProfileState extends State<AcceuilProfile> {
  @override
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            new Positioned(
                //constraints.biggest.height to get the height
                // * .05 to put the position top: 5%
                top: 20,
                //left: constraints.biggest.width * .30,
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
                )),
            Container(child: page(_selectedIndex))
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[900],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Interventions à venir',
            backgroundColor: Colors.blue[900],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Interventions effectuées',
            backgroundColor: Colors.black54,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: _onItemTapped,
      ),
    );
  }
}
