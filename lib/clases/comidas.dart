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
        'carbohidrato': _ingredientestoFirestore(carbohidrato),
        'proteina': _ingredientestoFirestore(proteina),
        'grasa': _ingredientestoFirestore(grasa),
      };
}

List<Ingrediente> _convierteIngredientes(List list) {
  return list
      .map((item) => Ingrediente.fromFirestore(item))
      .toList()
      .cast<Ingrediente>();
}

List<Map<String, String>> _ingredientestoFirestore(List<Ingrediente> list) {
  List<Map<String, String>> l = [];
  Map<String, String> ingrediente;
  for (int i = 0; i < list.length; i++) {
    ingrediente = {'nombre': list[i].nombre, 'cantidad': list[i].cantidad};
    l.add(ingrediente);
  }
  return l;
}

Stream<List<Comida>> comidasSnapshots(
  String usuariosId,
) {
  final db = FirebaseFirestore.instance;
  return db
      .collection("/usuarios/$usuariosId/comidas")
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
