import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  late int altura, edad, peso;
  late String nombre,
      medida1 = 'ninguna',
      medida2 = 'ninguna',
      medida3 = 'ninguna',
      medida4 = 'ninguna';
  late String apellidos, sexo;

  Usuario(this.nombre);

  Usuario.fromFirestore(Map<String, dynamic> data)
      : altura = data['altura'],
        apellidos = data['apellidos'],
        edad = data['edad'],
        nombre = data['nombre'],
        peso = data['peso'],
        sexo = data['sexo'],
        medida1 = data['medida1'],
        medida2 = data['medida2'],
        medida3 = data['medida3'],
        medida4 = data['medida4'];

  Map<String, dynamic> toFirestore() => {
        'altura': altura,
        'apellidos': apellidos,
        'edad': edad,
        'nombre': nombre,
        'peso': peso,
        'sexo': sexo,
        'medida1': medida1,
        'medida2': medida2,
        'medida3': medida3,
        'medida4': medida4,
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
