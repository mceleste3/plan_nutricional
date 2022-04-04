import 'package:cloud_firestore/cloud_firestore.dart';

class Comida {
  String? id;
  late String nombre, tipo;
  late List<Map<String, String>> carbohidrato;
  late List<Map<String, String>> proteina;
  late List<Map<String, String>> grasa;

  Comida(this.nombre);

  //Comida(
  //    {this.tipo, this.nombre, this.carbohidrato, this.proteina, this.grasa});

  Comida.r(
    this.tipo,
    this.nombre,
    this.carbohidrato,
    this.proteina,
    this.grasa,
  );

  Comida.fromFirestore(String _id, Map<String, dynamic> data)
      : id = _id,
        nombre = data['nombre'],
        tipo = data['tipo'],
        carbohidrato =
            (data['carbohidrato'] as List).cast<Map<String, String>>(),
        proteina = (data['proteina'] as List).cast<Map<String, String>>(),
        grasa = (data['grasa'] as List).cast<Map<String, String>>();

  Map<String, dynamic> toFirestore() => {
        'tipo': tipo,
        'nombre': nombre,
        'carbohidrato': carbohidrato,
        'proteina': proteina,
        'grasa': grasa,
      };
}

Stream<QuerySnapshot<Map<String, dynamic>>> comidasSnapshots(
    String usuariosId) {
  final db = FirebaseFirestore.instance;
  return db
      .collection("/usuarios/$usuariosId/comidas")
      .orderBy('orden')
      .snapshots();
}

//Agregar una comida
Future<void> addComida(String idUsuario, Comida c) async {
  final db = FirebaseFirestore.instance;
  final doc =
      await db.collection("/usuarios/$idUsuario/comidas").add(c.toFirestore());
  c.id = doc.id;
}
