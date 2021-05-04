import 'package:negomer_mobile/AcceuilP1.dart';
import 'package:negomer_mobile/agent/interventionsEffectues.dart';

page(id) {
  if (id == 0) {
    return AcceuilP1();
  } else if (id == 2) {
    return Historique();
  }
}
