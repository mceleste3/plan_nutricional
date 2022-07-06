import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plan_nutricional/clases/usuario.dart';
import 'package:plan_nutricional/clases/extras.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Extras extends StatelessWidget {
  const Extras({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    return Scaffold(
      body: StreamBuilder(
        stream: usuarioSnapshots(userid),
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
            stream: extraListSnapshots(userid),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      flex: 9,
                      child: Center(
                        child: Text("No hay extras"),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AgregarExtra(id: userid),
                      ),
                    )
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 20, right: 8, left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 18,
                        ),
                        Text(
                          'Medicamentos / Suplementos',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: const [
                          Text("Nombre",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          SizedBox(
                            width: 109,
                          ),
                          Text("Cantidad",
                              style: TextStyle(fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      flex: 8,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: extras.length,
                          itemBuilder: (context, index) {
                            return CasillaExtra(
                              extra: extras[index],
                              usuarioId: userid,
                            );
                          }),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AgregarExtra(id: userid),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AgregarExtra extends StatefulWidget {
  const AgregarExtra({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<AgregarExtra> createState() => _AgregarExtraState();
}

class _AgregarExtraState extends State<AgregarExtra> {
  late TextEditingController _nombre;
  late TextEditingController _cantidad;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(
      text: "",
    );

    _cantidad = TextEditingController(
      text: "",
    );
  }

  @override
  void dispose() {
    _nombre.dispose();
    _cantidad.dispose();
    super.dispose();
  }

  Future<void> _aceptarPulsado(Extra e, String id) async {
    e.nombre = _nombre.text;
    e.cantidad = _cantidad.text;
    addExtra(id, e);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    dynamic extra = Extra('', '');
    return ElevatedButton(
      onPressed: () {
        showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF515151),
              content: SizedBox(
                height: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*const Text(
                      'Repetición',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                   Desplegable(extra: extra),
                    const SizedBox(height: 30),*/
                    const Text(
                      'Nombre',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _nombre,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Cantidad',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _cantidad,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _aceptarPulsado(extra, widget.id);
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
      child: const Icon(Icons.add),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(50, 33),
      ),
    );
  }
}

class ExtraLista extends StatelessWidget {
  const ExtraLista({Key? key, required this.listaExtras, required this.id})
      : super(key: key);

  final List<Extra> listaExtras;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Medicamentos / Suplementos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: const [
                Text("Nombre", style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 109,
                ),
                Text("Cantidad", style: TextStyle(fontWeight: FontWeight.w500))
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: listaExtras.length,
              itemBuilder: (context, index) {
                return CasillaExtra(
                  extra: listaExtras[index],
                  usuarioId: id,
                );
              }),
        ],
      ),
    );
  }
}

class CasillaExtra extends StatefulWidget {
  const CasillaExtra({Key? key, required this.extra, required this.usuarioId})
      : super(key: key);
  final Extra extra;
  final String usuarioId;

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

  Future<void> _aceptarPulsado(String usuarioId, Extra e) async {
    if (_controller.text != '') {
      e.nombre = _controller.text;
    }
    if (_controller2.text != '') {
      e.cantidad = _controller2.text;
    }
    updateExtra(usuarioId, e);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 18),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
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
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: Container(
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
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF515151),
                      content: SizedBox(
                        height: 170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nombre',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextField(
                              style: const TextStyle(color: Colors.white70),
                              controller: _controller,
                              decoration: InputDecoration(
                                hintStyle:
                                    const TextStyle(color: Colors.white70),
                                hintText: widget.extra.nombre,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              'Cantidad',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextField(
                              style: const TextStyle(color: Colors.white70),
                              controller: _controller2,
                              decoration: InputDecoration(
                                hintStyle:
                                    const TextStyle(color: Colors.white70),
                                hintText: widget.extra.cantidad,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _aceptarPulsado(widget.usuarioId, widget.extra);
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
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.only(right: 1),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF515151),
                      content: const Text(
                        "Seguro que quieres eliminarlo?",
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .doc(
                                    "/usuarios/${widget.usuarioId}/extras/${widget.extra.id}")
                                .delete();
                            Navigator.pop(context, true);
                          },
                          child: const Text("Aceptar"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancelar"),
                        )
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}

/*
class Desplegable extends StatefulWidget {
  const Desplegable({
    Key? key,
    required this.extra,
  }) : super(key: key);

  @override
  State<Desplegable> createState() => _DesplegableState();
  final Extra extra;
}

class _DesplegableState extends State<Desplegable> {
  String dropdownValue = 'semanal';

  @override
  Widget build(BuildContext context) {
    widget.extra.repeticion = dropdownValue;
    return DropdownButton<String>(
      value: dropdownValue,
      borderRadius: BorderRadius.circular(10),
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      dropdownColor: Colors.grey.shade700,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      underline: Container(
        height: 2,
        color: Colors.white70,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.extra.repeticion = newValue.toLowerCase();
        });
      },
      items: <String>['diaria', 'semanal']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}*/
