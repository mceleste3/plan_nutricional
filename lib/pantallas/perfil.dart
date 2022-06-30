import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plan_nutricional/clases/usuario.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;

    const TextStyle titleStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      body: StreamBuilder(
        stream: usuarioSnapshots(userid),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Usuario>> snapshot,
        ) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final doc = snapshot.data!;
          var usuario = doc.data();
          final docUsuario =
              FirebaseFirestore.instance.collection("/usuarios").doc(userid);
          if (usuario == null) {
            return const Center(
              child: Text("El usuario no existente"),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text(user.email ?? "<no email>")),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 23),
                    child: Text(
                      'Nombre: ',
                      style: titleStyle,
                    ),
                  ),
                  Casilla(
                    doc: docUsuario,
                    user: usuario,
                    i: 0,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23),
                    child: Text(
                      'Apellidos: ',
                      style: titleStyle,
                    ),
                  ),
                  Casilla(
                    doc: docUsuario,
                    user: usuario,
                    i: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23),
                    child: Text(
                      'Edad: ',
                      style: titleStyle,
                    ),
                  ),
                  Casilla(
                    doc: docUsuario,
                    user: usuario,
                    i: 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23),
                    child: Text(
                      'Peso (kg): ',
                      style: titleStyle,
                    ),
                  ),
                  Casilla(
                    doc: docUsuario,
                    user: usuario,
                    i: 3,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23),
                    child: Text(
                      'Altura (cm): ',
                      style: titleStyle,
                    ),
                  ),
                  Casilla(
                    doc: docUsuario,
                    user: usuario,
                    i: 4,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23),
                    child: Text(
                      'Sexo: ',
                      style: titleStyle,
                    ),
                  ),
                  Casilla(
                    doc: docUsuario,
                    user: usuario,
                    i: 9,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23),
                    child: Text(
                      'Medida 1: ',
                      style: titleStyle,
                    ),
                  ),
                  Casilla(
                    doc: docUsuario,
                    user: usuario,
                    i: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23),
                    child: Text(
                      'Medida 2: ',
                      style: titleStyle,
                    ),
                  ),
                  Casilla(
                    doc: docUsuario,
                    user: usuario,
                    i: 6,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23),
                    child: Text(
                      'Medida 3 ',
                      style: titleStyle,
                    ),
                  ),
                  Casilla(
                    doc: docUsuario,
                    user: usuario,
                    i: 7,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23),
                    child: Text(
                      'Medida 4',
                      style: titleStyle,
                    ),
                  ),
                  Casilla(
                    doc: docUsuario,
                    user: usuario,
                    i: 8,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Casilla extends StatefulWidget {
  const Casilla(
      {Key? key, required this.user, required this.doc, required this.i})
      : super(key: key);
  final Usuario user;
  final dynamic doc;
  final dynamic i;

  @override
  State<Casilla> createState() => _CasillaState();
}

class _CasillaState extends State<Casilla> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: "",
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String datos(dynamic i, Usuario u) {
    String d = '';
    switch (i) {
      case 0:
        d = u.nombre;
        break;
      case 1:
        d = u.apellidos;
        break;
      case 2:
        d = u.edad.toString();
        break;
      case 3:
        d = u.peso.toString();
        break;
      case 4:
        d = u.altura.toString();
        break;
      case 5:
        d = u.medida1;
        break;
      case 6:
        d = u.medida2;
        break;
      case 7:
        d = u.medida3;
        break;
      case 8:
        d = u.medida4;
        break;
      case 9:
        d = u.sexo;
        break;
      default:
    }
    return (d);
  }

  Future<void> _aceptarPulsado(Usuario u, dynamic doc, dynamic i) async {
    switch (i) {
      case 0:
        u.nombre = _controller.text;
        break;
      case 1:
        u.apellidos = _controller.text;
        break;
      case 2:
        u.edad = int.parse(_controller.text);
        break;
      case 3:
        u.peso = int.parse(_controller.text);
        break;
      case 4:
        u.altura = int.parse(_controller.text);
        break;
      case 5:
        u.medida1 = _controller.text;
        break;
      case 6:
        u.medida2 = _controller.text;
        break;
      case 7:
        u.medida3 = _controller.text;
        break;
      case 8:
        u.medida4 = _controller.text;
        break;
      case 9:
        u.sexo = _controller.text;
        break;
      default:
    }

    doc.update(u.toFirestore());
    Navigator.pop(context, true);
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
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                boxShadow: const [
                  BoxShadow(blurRadius: 2, color: Colors.black38)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 6),
                child: Text(
                  datos(widget.i, widget.user),
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
                      content: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: _controller,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.white60),
                          hintText: datos(widget.i, widget.user),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _aceptarPulsado(widget.user, widget.doc, widget.i);
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
                minimumSize: const Size(50, 33),
              ),
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
