import 'package:cloud_firestore/cloud_firestore.dart';

class Ingrediente {
  String nombre, cantidad;
  Ingrediente(this.nombre, this.cantidad);

  Ingrediente.fromFirestore(Map<String, dynamic> data)
      : nombre = data['nombre'],
        cantidad = data['cantidad'];

  @override
  String toString() => "$nombre ($cantidad)";
}

class Comida {
  String? id;
  late String nombre, tipo;
  late List<Ingrediente> carbohidrato;
  late List<Ingrediente> proteina;
  late List<Ingrediente> grasa;

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
        carbohidrato = _convierteIngredientes(data['carbohidrato'] as List),
        proteina = _convierteIngredientes(data['proteina'] as List),
        grasa = _convierteIngredientes(data['grasa'] as List);

  Map<String, dynamic> toFirestore() => {
        'tipo': tipo,
        'nombre': nombre,
        'carbohidrato': carbohidrato,
        'proteina': proteina,
        'grasa': grasa,
      };
}

List<Ingrediente> _convierteIngredientes(List list) {
  return list
      .map((item) => Ingrediente.fromFirestore(item))
      .toList()
      .cast<Ingrediente>();
}

Stream<List<Comida>> comidasSnapshots(
  String usuariosId,
) {
  final db = FirebaseFirestore.instance;
  return db
      .collection("/usuarios/$usuariosId/comidas")
      // .orderBy('orden')
      .snapshots()
      .map((querySnap) {
    return querySnap.docs
        .map((doc) => Comida.fromFirestore(doc.id, doc.data()))
        .toList();
  });
}

//Agregar una comida
Future<void> addComida(String idUsuario, Comida c) async {
  final db = FirebaseFirestore.instance;
  final doc =
      await db.collection("/usuarios/$idUsuario/comidas").add(c.toFirestore());
  c.id = doc.id;
}
