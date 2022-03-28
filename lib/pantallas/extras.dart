/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plan_nutricional/clases/usuario.dart';
import 'package:plan_nutricional/clases/extras.dart';

class Extras extends StatelessWidget {
  String id = 'xWEDD9TJRiBiizMSSgbN';

  Extras({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text('Lista de extras'),
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
            stream: extrasSnapshots(id),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final extraSnaps = snapshot.data!.docs;
              final extras = extraSnaps
                  .map((docSnap) =>
                      Extras.fromfirestore(docSnap.id, docSnap.data()))
                  .toList();
              if (extras.isEmpty) {
                return const Center(
                  child: Text("No hay extras"),
                );
              }
              return Container(
                child: Column(
                  children: [
                    Text('${extras[0].nombre}))'),
                  ],
                ),
              );

              /* return ListView.builder(
          itemCount: lista_comida.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Text(lista_comida[index].nombre.toString()),
                ],
              ),
            );
          }),
        */
            },
          );
        },
      ),
    );
  }
}
*/