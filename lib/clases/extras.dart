import 'package:cloud_firestore/cloud_firestore.dart';

class Extra {
  late String id;
  late String nombre, cantidad, repeticion;
  // late List<String> horas;
  // late List<String> dias;

  Extra(this.nombre, this.cantidad);

  Extra.fromfirestore(String _id, Map<String, dynamic> data)
      : id = _id,
        nombre = data['nombre'],
        cantidad = data['cantidad'],
        repeticion = data['repeticion'];
  //     horas = (data['horas'] as List).cast<String>(),
  //   dias = (data['dias'] as List).cast<String>();

  Map<String, dynamic> toFirestore() => {
        'cantidad': cantidad,
        'nombre': nombre,
        'repeticion': repeticion,
        // 'horas': horas,
        // 'dias': dias,
      };
}

Stream<List<Extra>> extraListSnapshots(
  String usuarioId,
) {
  final db = FirebaseFirestore.instance;
  return db
      .collection("/usuarios/$usuarioId/extras")
      .snapshots()
      .map((querySnap) {
    return querySnap.docs
        .map((doc) => Extra.fromfirestore(doc.id, doc.data()))
        .toList();
  });
}

Stream<Extra> extraSnapshots(String usuarioId, String extraId) {
  return FirebaseFirestore.instance
      .doc("/usuarios/$usuarioId/extras/$extraId")
      .snapshots()
      .map((doc) => Extra.fromfirestore(doc.id, doc.data()!));
}

//añadir un extra
Future<void> addExtra(String idUsuario, Extra e) async {
  final db = FirebaseFirestore.instance;
  final doc =
      await db.collection("/usuarios/$idUsuario/extras").add(e.toFirestore());
  e.id = doc.id;
}

//editar extra
Future<void> updateExtra(String usuarioId, Extra extra) async {
  return FirebaseFirestore.instance
      .doc(
        "/usuarios/$usuarioId/extras/${extra.id}",
      )
      .update(extra.toFirestore());
}
