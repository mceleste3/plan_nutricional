import 'package:cloud_firestore/cloud_firestore.dart';

enum FranjaHoraria {
  desayuno,
  snack,
  almuerzo,
  merienda,
  cena,
}

class Calendario {
  String? id;
  DateTime fecha;

  /*
  - Si en franjas no existe una llave, es que es franja está vacía.
  - La llave es un enum (un entero) que es más conveniente.
  */
  Map<FranjaHoraria, String> franjas = {};

  Calendario(this.fecha);

  Timestamp _conviertefechaTo(DateTime f) {
    Timestamp times = Timestamp.fromDate(f);
    return times;
  }

  Calendario.fromFirestore(String _id, Map<String, dynamic> data)
      : id = _id,
        fecha = _conviertefechaFrom(data['fecha'] as Timestamp) {
    final franjasFirestore = data['franjas'] as Map<String, dynamic>;
    for (var entry in franjasFirestore.entries) {
      switch (entry.key) {
        case 'desayuno':
          franjas[FranjaHoraria.desayuno] = entry.value;
          break;
        case 'snack':
          franjas[FranjaHoraria.snack] = entry.value;
          break;
        case 'almuerzo':
          franjas[FranjaHoraria.almuerzo] = entry.value;
          break;
        case 'merienda':
          franjas[FranjaHoraria.merienda] = entry.value;
          break;
        case 'cena':
          franjas[FranjaHoraria.cena] = entry.value;
          break;
        default:
          throw "Una llave de las franjas horarias es desconocida ${entry.key}";
      }
    }
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {
      'fecha': _conviertefechaTo(fecha),
    };
    final Map<String, String> franjasFirestore = {};
    for (var entry in franjas.entries) {
      franjasFirestore[entry.key.toString()] = entry.value;
    }
    data['franjas'] = franjasFirestore;
    return data;
  }
}

DateTime _conviertefechaFrom(Timestamp f) {
  DateTime times = f.toDate();
  return times;
}

Stream<List<Calendario>> calendarioListSnapshots(String usuarioId) {
  final db = FirebaseFirestore.instance;
  return db
      .collection("/usuarios/$usuarioId/calendario")
      .snapshots()
      .map((querySnap) {
    return querySnap.docs
        .map((doc) => Calendario.fromFirestore(doc.id, doc.data()))
        .toList();
  });
}

Future<void> addCalendario(String idUsuario, Calendario c) async {
  final db = FirebaseFirestore.instance;
  final doc = await db
      .collection("/usuarios/$idUsuario/calendario")
      .add(c.toFirestore());
  c.id = doc.id;
}
