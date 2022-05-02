import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plan_nutricional/clases/usuario.dart';
import 'package:plan_nutricional/clases/extras.dart';

class Extras extends StatelessWidget {
  final String id = 'CKqi4OfuXeMHe41cyOug';
  const Extras({Key? key}) : super(key: key);

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
            stream: extraListSnapshots(id),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Extra>> snapshot,
            ) {
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final extras = snapshot.data!;

              if (extras.isEmpty) {
                return const Center(
                  child: Text("No hay extras"),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 38, left: 20),
                child: ExtraLista(listaExtras: extras),
              );
            },
          );
        },
      ),
    );
  }
}

class ExtraLista extends StatelessWidget {
  const ExtraLista({
    Key? key,
    required this.listaExtras,
  }) : super(key: key);

  final List<Extra> listaExtras;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medicamentos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: listaExtras.length,
            itemBuilder: (context, index) {
              return CasillaExtra(
                extra: listaExtras[index],
              );
            }),
      ],
    );
  }
}

class CasillaExtra extends StatefulWidget {
  const CasillaExtra({Key? key, required this.extra}) : super(key: key);
  final Extra extra;

  @override
  State<CasillaExtra> createState() => _CasillaExtraState();
}

class _CasillaExtraState extends State<CasillaExtra> {
  late TextEditingController _controller;
  late TextEditingController _controller2;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: "",
    );

    _controller2 = TextEditingController(
      text: "",
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  Future<void> _aceptarPulsado(Extra e) async {
    e.nombre = _controller.text;
    e.cantidad = _controller2.text;

    //doc.update(e.toFirestore());
    //Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                boxShadow: const [
                  BoxShadow(blurRadius: 2, color: Colors.black38)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 6),
                child: Text(
                  widget.extra.nombre,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                boxShadow: const [
                  BoxShadow(blurRadius: 2, color: Colors.black38)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 6),
                child: Text(
                  widget.extra.cantidad,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF515151),
                        content: Column(
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: _controller,
                              decoration: InputDecoration(
                                hintStyle:
                                    const TextStyle(color: Colors.white60),
                                hintText: widget.extra.nombre,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                              ),
                            ),
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: _controller2,
                              decoration: InputDecoration(
                                hintStyle:
                                    const TextStyle(color: Colors.white60),
                                hintText: widget.extra.cantidad,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _aceptarPulsado(widget.extra);
                            },
                            child: const Text(
                              "Aceptar",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.edit),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                )
                // backgroundColor: Colors.white,
                ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
