import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    Comida comida = Comida.r(
      '',
      '',
      [],
      [],
      [],
    );

    Future<void> _guardarPulsado(Comida c) async {
      c.nombre = _nombre.text;
      addComida(userid, c);
      Navigator.of(context).pop();
    }

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
                Desplegable(comida: comida),
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
                Columna(
                  nombre: 'Carbohidrato',
                  listaIngredientes: comida.carbohidrato,
                  comida: comida,
                ),
                Columna(
                  nombre: 'Proteína',
                  listaIngredientes: comida.proteina,
                  comida: comida,
                ),
                Columna(
                  nombre: 'Grasa',
                  listaIngredientes: comida.grasa,
                  comida: comida,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 200, top: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      _guardarPulsado(comida);
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15)),
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Columna extends StatefulWidget {
  const Columna({
    Key? key,
    required this.nombre,
    required this.listaIngredientes,
    required this.comida,
  }) : super(key: key);

  final String nombre;
  final List<Ingrediente> listaIngredientes;
  final Comida comida;

  @override
  State<Columna> createState() => _ColumnaState();
}

class _ColumnaState extends State<Columna> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                widget.listaIngredientes.add(Ingrediente('', ''));
              }),
              child: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(50, 33),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                if (widget.listaIngredientes.isNotEmpty) {
                  widget.listaIngredientes.removeLast();
                }
              }),
              child: const Icon(Icons.remove),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(50, 33),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 90),
              child: Text("Nombre"),
            ),
            SizedBox(width: 125),
            Text("Cantidad"),
          ],
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.listaIngredientes.length,
          itemBuilder: (context, index) {
            return EditorCasillas(
              ingrediente: widget.listaIngredientes[index],
            );
          },
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}

class EditorCasillas extends StatefulWidget {
  const EditorCasillas({Key? key, required this.ingrediente}) : super(key: key);

  final Ingrediente ingrediente;

  @override
  State<EditorCasillas> createState() => _EditorCasillasState();
}

class _EditorCasillasState extends State<EditorCasillas> {
  late TextEditingController _nombre;
  late TextEditingController _cantidad;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController();
    _cantidad = TextEditingController();
  }

  @override
  void dispose() {
    _nombre.dispose();
    _cantidad.dispose();
    super.dispose();
  }

  void cambioNombre(String nombre) {
    // Este cambio afecta al objeto comida, realmente...
    widget.ingrediente.nombre = nombre;
  }

  void cambioCantidad(String cantidad) {
    // Este cambio afecta al objeto comida, realmente...
    widget.ingrediente.cantidad = cantidad;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 40,
              child: TextField(
                controller: _nombre,
                onChanged: cambioNombre,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 30),
            SizedBox(
              width: 90,
              height: 40,
              child: TextField(
                controller: _cantidad,
                onChanged: cambioCantidad,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Desplegable extends StatefulWidget {
  const Desplegable({
    Key? key,
    required this.comida,
  }) : super(key: key);

  @override
  State<Desplegable> createState() => _DesplegableState();
  final Comida comida;
}

class _DesplegableState extends State<Desplegable> {
  String dropdownValue = 'Desayuno';

  @override
  Widget build(BuildContext context) {
    widget.comida.tipo = dropdownValue;
    return DropdownButton<String>(
      value: dropdownValue,
      borderRadius: BorderRadius.circular(10),
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 15),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.comida.tipo = newValue.toLowerCase();
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
