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
              return Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 9,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: comidas.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 6, left: 2, top: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: ComidaWidget(
                                      listaComida: comidas,
                                      index: index,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          final docComidas = FirebaseFirestore
                                              .instance
                                              .collection(
                                                  "/usuarios/$id/comidas")
                                              .doc(comidas[index].id);
                                          List<dynamic> infoComidas = [
                                            comidas[0],
                                            docComidas
                                          ];
                                          Navigator.of(context).pushNamed(
                                              '/editar',
                                              arguments: infoComidas);
                                        },
                                        child: const Icon(Icons.edit),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            padding:
                                                const EdgeInsets.only(right: 1))
                                        // backgroundColor: Colors.white,
                                        ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            const EdgeInsets.only(right: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  const Color(0xFF515151),
                                              content: const Text(
                                                "Seguro que quieres eliminar esta comida de la lista?",
                                                style: TextStyle(
                                                    color: Colors.white70),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .doc(
                                                            "/usuarios/$id/comidas/${comidas[index].id}")
                                                        .delete();
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  child: const Text("Aceptar"),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: const Text("Cancelar"),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(Icons.delete),
                                      // backgroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/agregar');
                          },
                          child: const Icon(Icons.add),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(50, 33),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ); /*
                  ListView.builder(
                itemCount: comidas.length,
                itemBuilder: (context, index) {
                  final comida = comidas[index];
                  return ListTile(
                    title: Text(comida.nombre),
                    subtitle: Text(comida.grasa.join(", ")),
                  );
                },
              );*/
            },
          );
        },
      ),
    );
  }
}

class ComidaWidget extends StatelessWidget {
  const ComidaWidget({
    Key? key,
    required this.listaComida,
    required this.index,
  }) : super(key: key);

  final List<Comida> listaComida;
  final int index;
  static const TextStyle titleStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);
  static const TextStyle subtitleStyle = TextStyle(
      color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 13);
  static const TextStyle ingredientStyle =
      TextStyle(color: Colors.black, fontSize: 13);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black54)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${listaComida[index].nombre}",
            style: titleStyle,
          ),
          Text(
            "${listaComida[index].tipo.toUpperCase()}",
            style: subtitleStyle,
          ),
          Text("Carbohidrato: ${listaComida[index].carbohidrato.join(", ")}",
              style: ingredientStyle),
          Text(
            "Proteína: ${listaComida[index].proteina.join(", ")}",
            style: ingredientStyle,
          ),
          Text(
            "Grasa: ${listaComida[index].grasa.join(", ")}",
            style: ingredientStyle,
          ),
        ],
      ),
    );
  }
}
