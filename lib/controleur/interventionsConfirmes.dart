import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Historique extends StatefulWidget {
  Historique();

  @override
  _HistoriqueState createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;
    return Container(
        height: hauteur / 1.35,
        color: Colors.blueGrey[50],
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, i) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: largeur / 25),
              child: Card(
                elevation: 10,
                shadowColor: Colors.black26,
                child: Container(
                    width: largeur,
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                                  "Intervenant\n",
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  'Abgeto Wilfried',
                                  style: GoogleFonts.lato(
                                    fontSize: 17,
                                    color: Colors.black45,
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
                                  color: Colors.black45,
                                  size: 22,
                                ),
                                Text(
                                  'Agbalépédogan,',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.black45,
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
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  '18h : 45m',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.black45,
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
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  '02h : 45m',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.black45,
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
            );
          },
        ));
  }
}
