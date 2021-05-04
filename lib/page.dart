import 'package:negomer_mobile/AcceuilP1.dart';
import 'package:negomer_mobile/agenda.dart';
import 'package:negomer_mobile/historique.dart';
import 'package:negomer_mobile/postes_screen.dart';

page(id, int type) {
  if(type==1){
    if (id == 0) {
      return AcceuilP1();
    } else if (id == 1) {
      return PostesScreen();
    }
    else if (id == 2) {
      return Agenda();
    } else if (id == 3) {
      return Historique();
    }
  }
  else{
    if (id == 0) {
      return AcceuilP1();
    } else if (id == 1) {
      return Agenda();
    } else if (id == 2) {
      return Historique();
    }
  }

}
