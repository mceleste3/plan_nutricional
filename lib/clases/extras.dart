import 'package:cloud_firestore/cloud_firestore.dart';

class Extras {
  late String id;
  late String nombre, cantidad, repeticion;
  late List<String> horas;
  late List<String> dias;

  Extras(this.nombre);

  Extras.fromfirestore(String _id, Map<String, dynamic> data)
      : id = _id,
        nombre = data['nombre'],
        cantidad = data['cantidad'],
        repeticion = data['repeticion'],
        horas = (data['horas'] as List).cast<String>(),
        dias = (data['dias'] as List).cast<String>();

  Map<String, dynamic> toFirestore() => {
        'cantidad': cantidad,
        'nombre': nombre,
        'repeticion': repeticion,
        'horas': horas,
        'dias': dias,
      };
}

Stream<QuerySnapshot<Map<String, dynamic>>> extrasSnapshots(String usuariosId) {
  final db = FirebaseFirestore.instance;
  return db
      .collection("/usuarios/$usuariosId/extras")
      .orderBy('orden')
      .snapshots();
}

Future<void> addExtra(String idUsuario, Extras e) async {
  final db = FirebaseFirestore.instance;
  final doc =
      await db.collection("/usuarios/$idUsuario/extras").add(e.toFirestore());
  e.id = doc.id;
}
