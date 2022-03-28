import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plan_nutricional/clases/usuario.dart';

class Perfil extends StatelessWidget {
  String id = 'CKqi4OfuXeMHe41cyOug';
  late String nombre;

  Perfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: usuarioSnapshots(id),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Usuario>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final doc = snapshot.data!;
            var usuario = doc.data();
            final docUsuario =
                FirebaseFirestore.instance.collection("/usuarios").doc(id);
            if (usuario == null) {
              return const Center(
                child: Text("El usuario no existente"),
              );
            }
            return Center(
              child: Text("Apellidos: ${usuario.apellidos}"),
            );
          }),
    );
  }
}
