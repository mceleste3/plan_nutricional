import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plan_nutricional/clases/usuario.dart';
import 'package:plan_nutricional/clases/comidas.dart';

class PantallaComidas extends StatelessWidget {
  final String id = 'CKqi4OfuXeMHe41cyOug';

  const PantallaComidas({Key? key}) : super(key: key);

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
          if (usuario == null) {
            return const Center(
              child: Text("El usuario no existente"),
            );
          }
          return StreamBuilder(
            stream: comidasSnapshots(id),
            builder:
                (BuildContext context, AsyncSnapshot<List<Comida>> snapshot) {
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final comidas = snapshot.data!;
              if (comidas.isEmpty) {
                return const Center(
                  child: Text("No hay comidas"),
                );
              }
              return ListView.builder(
                itemCount: comidas.length,
                itemBuilder: (context, index) {
                  final comida = comidas[index];
                  return ListTile(
                    title: Text(comida.nombre),
                    subtitle: Text(comida.grasa.join(", ")),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
