import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  late int altura, edad, peso;
  late String nombre;
  late String apellidos, sexo;

  Usuario(this.nombre);

  Usuario.fromFirestore(Map<String, dynamic> data)
      : altura = data['altura'],
        apellidos = data['apellidos'],
        edad = data['edad'],
        nombre = data['nombre'],
        peso = data['peso'],
        sexo = data['sexo'];

  Map<String, dynamic> toFirestore() => {
        'altura': altura,
        'apellidos': apellidos,
        'edad': edad,
        'nombre': nombre,
        'peso': peso,
        'sexo': sexo,
      };
}

Stream<DocumentSnapshot<Usuario>> usuarioSnapshots(String id) {
  final db = FirebaseFirestore.instance;
  return db
      .doc("/usuarios/$id")
      .withConverter<Usuario>(
        fromFirestore: (docSnap, _) => Usuario.fromFirestore(docSnap.data()!),
        toFirestore: (Usuario usuario, _) => usuario.toFirestore(),
      )
      .snapshots();
}
