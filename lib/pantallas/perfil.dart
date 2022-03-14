import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plan_nutricional/pantallas/usuario.dart';

class Perfil extends StatelessWidget {
  String _id = 'xWEDD9TJRiBiizMSSgbN';
  late String _nombre;

  Perfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: usuarioSnapshots(_id),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Usuario>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final doc = snapshot.data!;
            var usuario = doc.data();
            final docUsuario = FirebaseFirestore.instance
                .collection("/usuarios")
                .doc('xWEDD9TJRiBiizMSSgbN');
            if (usuario == null) {
              return Center(
                child: Text("hola usuario no existente"),
              );
            }
            return Center(
              child: Text("${usuario.nombre}"),
            );
          }),
    );
  }
}
