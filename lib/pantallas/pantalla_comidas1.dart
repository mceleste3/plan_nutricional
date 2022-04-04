import 'package:flutter/material.dart';
import 'package:plan_nutricional/clases/comidas.dart';
import 'package:plan_nutricional/pantallas/barra_navegacion.dart';

class PantallaComidas extends StatelessWidget {
  final List<Comida> listaComida;

  const PantallaComidas({
    Key? key,
    required this.listaComida,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text(
          'Lista de comidas',
          style: TextStyle(),
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, right: 8, left: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 9,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: listaComida.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 6, left: 2, top: 2),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: ComidaWidget(
                              listaComida: listaComida,
                              index: index,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 1,
                            child: FloatingActionButton(
                              onPressed: () {},
                              child: const Icon(Icons.edit),
                              // backgroundColor: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 1,
                            child: FloatingActionButton(
                              onPressed: () {
                                showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0xFF515151),
                                      content: const Text(
                                        "Seguro que quieres eliminar esta comida de la lista?",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Aceptar"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            listaComida.removeAt(index);
                                            Navigator.pop(context, false);
                                          },
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
                          )
                        ],
                      ),
                    );
                  }),
            ),
            Expanded(
              flex: 1,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraNavegacion(),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 70,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black54)]),
      child: Column(
        children: [
          Text(
            "${listaComida[index].nombre}:",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            "Tipo: ${listaComida[index].tipo}",
            style: const TextStyle(
              color: Colors.lightBlue,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
