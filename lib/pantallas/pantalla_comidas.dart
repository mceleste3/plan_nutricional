import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plan_nutricional/clases/usuario.dart';
import 'package:plan_nutricional/clases/comidas.dart';

class PantallaComidas extends StatelessWidget {
  String id = 'xWEDD9TJRiBiizMSSgbN';

  PantallaComidas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text('Lista de comidas'),
      )),
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
          return StreamBuilder(
            stream: comidasSnapshots(id),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final comidaSnaps = snapshot.data!.docs;
              final comidas = comidaSnaps
                  .map(
                    (docSnap) =>
                        Comida.fromFirestore(docSnap.id, docSnap.data()),
                  )
                  .toList();
              if (comidas.isEmpty) {
                return const Center(
                  child: Text("No hay comidas"),
                );
              }
              return Column(
                children: [
                  Text('${comidas[0].nombre}))'),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
