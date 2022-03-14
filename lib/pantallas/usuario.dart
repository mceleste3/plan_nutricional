import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  late List<String> perfil;
  late String nombre;

  Usuario() {
    perfil = [];
    nombre = 'Juan';
  }

  Usuario.fromFirestore(Map<String, dynamic> data)
      : perfil = (data['perfil'] as List).cast<String>(),
        nombre = data['nombre'];

  Map<String, dynamic> toFirestore() => {'perfil': perfil, 'nombre': nombre};
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
