import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plan_nutricional/clases/comidas.dart';

class EditarComida extends StatefulWidget {
  const EditarComida({Key? key}) : super(key: key);

  @override
  State<EditarComida> createState() => _EditarComidaState();
}

class _EditarComidaState extends State<EditarComida> {
  late TextEditingController _nombre;
  late List<dynamic> _arguments;

  @override
  void initState() {
    _nombre = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  Future<void> _guardarPulsado(
    Comida c,
    dynamic doc,
  ) async {
    if (_nombre.text != '') {
      c.nombre = _nombre.text;
    }
    doc.update(c.toFirestore());
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context) != null) {
      _arguments = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    }
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Tipo de comida',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Desplegable(
              comida: _arguments[0],
              doc: _arguments[1],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Nombre del plato',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              width: 200,
              child: TextField(
                controller: _nombre,
                decoration: InputDecoration(
                  hintText: "${_arguments[0].nombre}",
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Columna(
              nombre: 'Carbohidrato',
              comida: _arguments[0],
              doc: _arguments[1],
            ),
            const SizedBox(
              height: 10,
            ),
            Columna(
                nombre: 'Proteína', comida: _arguments[0], doc: _arguments[1]),
            const SizedBox(
              height: 10,
            ),
            Columna(nombre: 'Grasa', comida: _arguments[0], doc: _arguments[1]),
            Padding(
              padding: const EdgeInsets.only(left: 200, top: 40),
              child: ElevatedButton(
                onPressed: () {
                  _guardarPulsado(_arguments[0], _arguments[1]);
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(fontSize: 16),
                ),
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class Columna extends StatefulWidget {
  final String nombre;
  const Columna(
      {Key? key, required this.nombre, required this.comida, required this.doc})
      : super(key: key);

  @override
  State<Columna> createState() => _ColumnaState();
  final Comida comida;
  final dynamic doc;
}

class _ColumnaState extends State<Columna> {
  final TextEditingController _nombre = TextEditingController(),
      _cantidad = TextEditingController();

  int length(String nom) {
    int i = 0;
    if (nom == 'Carbohidrato') {
      i = widget.comida.carbohidrato.length;
    }
    if (nom == 'Proteína') {
      i = widget.comida.proteina.length;
    }
    if (nom == 'Grasa') {
      i = widget.comida.grasa.length;
    }
    return i;
  }

  Ingrediente macronutriente(String nom, int index) {
    Ingrediente c = widget.comida.carbohidrato[0];
    if (nom == 'Carbohidrato') {
      c = widget.comida.carbohidrato[index];
    }
    if (nom == 'Proteína') {
      c = widget.comida.proteina[index];
    }
    if (nom == 'Grasa') {
      c = widget.comida.grasa[index];
    }
    return c;
  }

  Future<void> cambioCantidad(int index, String nom, String cantidad) async {
    if (nom == 'Carbohidrato') {
      widget.comida.carbohidrato[index].cantidad = cantidad;
    }
    if (nom == 'Proteína') {
      widget.comida.proteina[index].cantidad = cantidad;
    }
    if (nom == 'Grasa') {
      widget.comida.grasa[index].cantidad = cantidad;
    }
  }

  Future<void> cambioNombre(int index, String nom, String cantidad) async {
    if (nom == 'Carbohidrato') {
      widget.comida.carbohidrato[index].nombre = cantidad;
    }
    if (nom == 'Proteína') {
      widget.comida.proteina[index].nombre = cantidad;
    }
    if (nom == 'Grasa') {
      widget.comida.grasa[index].nombre = cantidad;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${widget.nombre}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text("Nombre"),
          SizedBox(
            width: 80,
          ),
          Text("Cantidad")
        ]),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: length(widget.nombre),
            itemBuilder: (context, index) {
              Ingrediente i = macronutriente(widget.nombre, index);
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: TextField(
                          controller: _nombre,
                          onChanged: (dynamic _nombre) {
                            setState(() {
                              cambioNombre(index, widget.nombre, _nombre);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: i.nombre,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        width: 90,
                        height: 40,
                        child: TextField(
                          controller: _cantidad,
                          onChanged: (dynamic _cantidad) {
                            setState(() {
                              cambioCantidad(index, widget.nombre, _cantidad);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: i.cantidad,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class Desplegable extends StatefulWidget {
  const Desplegable({Key? key, required this.comida, required this.doc})
      : super(key: key);

  @override
  State<Desplegable> createState() => _DesplegableState();
  final Comida comida;
  final dynamic doc;
}

class _DesplegableState extends State<Desplegable> {
  late String dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.comida.tipo.toUpperCase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      borderRadius: BorderRadius.circular(10),
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.comida.tipo = newValue.toLowerCase();
        });
      },
      items: <String>['DESAYUNO', 'SNACK', 'ALMUERZO', 'MERIENDA', 'CENA']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
