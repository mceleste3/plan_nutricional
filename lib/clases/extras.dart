import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Extra {
  String? id;
  String nombre, cantidad;
  String repeticion = "";
  List<TimeOfDay>? horas;
  List<DateTime>? dias;

  Extra(this.nombre, this.cantidad);
  Extra.horas(this.nombre, this.cantidad, this.repeticion, this.horas);
  Extra.dias(this.nombre, this.cantidad, this.repeticion, this.dias);

  Extra.fromfirestore(String _id, Map<String, dynamic> data)
      : id = _id,
        nombre = data['nombre'],
        cantidad = data['cantidad'],
        repeticion = data['repeticion'] {
    if (data.containsKey('horas')) {
      horas = (data['horas'] as List).cast<TimeOfDay>();
    } else if (data.containsKey('dias')) {
      dias = (data['dias'] as List)
          .map((ts) => ts.toDate())
          .cast<DateTime>()
          .toList();
    }
  }

  Map<String, dynamic> toFirestore() {
    final datos = <String, dynamic>{
      'cantidad': cantidad,
      'nombre': nombre,
      'repeticion': repeticion,
    };
    if (horas != null) {
      datos['horas'] = horas; //tipo
    }
    if (dias != null) {
      datos['dias'] = dias;
    }
    return datos;
  }
}

Stream<List<Extra>> extraListSnapshots(String usuarioId) {
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
Future<void> addExtra(String idUsuario, Extra extra) async {
  final db = FirebaseFirestore.instance;
  final doc = await db
      .collection("/usuarios/$idUsuario/extras")
      .add(extra.toFirestore());
  extra.id = doc.id;
}

//editar extra
Future<void> updateExtra(String usuarioId, Extra extra) async {
  return FirebaseFirestore.instance
      .doc(
        "/usuarios/$usuarioId/extras/${extra.id}",
      )
      .update(extra.toFirestore());
}
