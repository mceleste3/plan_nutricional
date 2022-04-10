import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plan_nutricional/clases/comidas.dart';

class AddComida extends StatefulWidget {
  const AddComida({Key? key}) : super(key: key);

  @override
  State<AddComida> createState() => _AddComidaState();
}

class _AddComidaState extends State<AddComida> {
  late TextEditingController _nombre;

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

  Future<void> _guardarPulsado() async {
    final c = Comida.r(
      '',
      _nombre.text,
      [Ingrediente('', ''), Ingrediente('', '')],
      [Ingrediente('', ''), Ingrediente('', '')],
      [Ingrediente('', ''), Ingrediente('', '')],
    );
    final docSnap = FirebaseFirestore.instance
        .collection('/usuarios')
        .doc('CKqi4OfuXeMHe41cyOug');
    addComida('CKqi4OfuXeMHe41cyOug', c);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir comida')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Tipo de comida',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Desplegable(),
                const SizedBox(
                  height: 10,
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
                  width: 130,
                  child: TextField(
                    controller: _nombre,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Casilla(
                  nutriente: 'Carbohidrato',
                ),
                const Casilla(nutriente: 'Proteína'),
                const Casilla(nutriente: 'Grasa'),
                Padding(
                  padding: const EdgeInsets.only(left: 200, top: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      _guardarPulsado();
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Casilla extends StatelessWidget {
  final String nutriente;
  const Casilla({Key? key, required this.nutriente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$nutriente',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(50, 33),
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Columna(
                nombre: 'Nombre',
              ),
              SizedBox(
                width: 20,
              ),
              Columna(nombre: 'Cantidad')
            ],
          ),
        ),
      ],
    );
  }
}

class Columna extends StatefulWidget {
  final String nombre;
  const Columna({Key? key, required this.nombre}) : super(key: key);

  @override
  State<Columna> createState() => _ColumnaState();
}

class _ColumnaState extends State<Columna> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${widget.nombre}",
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          width: 130,
          height: 40,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class Desplegable extends StatefulWidget {
  const Desplegable({Key? key}) : super(key: key);

  @override
  State<Desplegable> createState() => _DesplegableState();
}

class _DesplegableState extends State<Desplegable> {
  String dropdownValue = 'Desayuno';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      borderRadius: BorderRadius.circular(10),
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 15),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Desayuno', 'Snack', 'Almuerzo', 'Merienda', 'Cena']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
