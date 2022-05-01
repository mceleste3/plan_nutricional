import 'package:flutter/material.dart';
import 'package:plan_nutricional/clases/comidas.dart';

class EditarComida extends StatefulWidget {
  const EditarComida({Key? key}) : super(key: key);

  @override
  State<EditarComida> createState() => _EditarComidaState();
}

class _EditarComidaState extends State<EditarComida> {
  late TextEditingController _nombre;
  late String comidaId, usuarioId;

  @override
  void initState() {
    _nombre = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context) != null) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      usuarioId = arguments[0];
      comidaId = arguments[1];
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Comida>(
      stream: comidaSnapshots(usuarioId, comidaId),
      builder: (BuildContext context, AsyncSnapshot<Comida> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final comida = snapshot.data!;

        Future<void> _actualiza() => updateComida(usuarioId, comida);

        Future<void> _guardarYSalir() async {
          if (_nombre.text != '') {
            comida.nombre = _nombre.text;
            await _actualiza();
          }
          Navigator.pop(context, true);
        }

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Text(
                  'Tipo de comida',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Desplegable(
                  comida: comida,
                  actualiza: _actualiza,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Nombre del plato',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  width: 200,
                  child: TextField(
                    controller: _nombre,
                    decoration: InputDecoration(
                      hintText: comida.nombre,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Columna(
                  nombre: 'Carbohidrato',
                  listaIngredientes: comida.carbohidrato,
                  actualiza: _actualiza,
                ),
                const SizedBox(height: 10),
                Columna(
                  nombre: 'Proteína',
                  listaIngredientes: comida.proteina,
                  actualiza: _actualiza,
                ),
                const SizedBox(height: 10),
                Columna(
                  nombre: 'Grasa',
                  listaIngredientes: comida.grasa,
                  actualiza: _actualiza,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 200, top: 40),
                  child: ElevatedButton(
                    onPressed: _guardarYSalir,
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15)),
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        );
      },
    );
  }
}

class Columna extends StatefulWidget {
  const Columna({
    Key? key,
    required this.nombre,
    required this.actualiza,
    required this.listaIngredientes,
  }) : super(key: key);

  final String nombre;
  final Function actualiza;
  final List<Ingrediente> listaIngredientes;

  @override
  State<Columna> createState() => _ColumnaState();
}

class _ColumnaState extends State<Columna> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              actualiza: widget.actualiza,
            );
          },
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}

class EditorCasillas extends StatefulWidget {
  const EditorCasillas({
    Key? key,
    required this.ingrediente,
    required this.actualiza,
  }) : super(key: key);

  final Ingrediente ingrediente;
  final Function actualiza;

  @override
  State<EditorCasillas> createState() => _EditorCasillasState();
}

class _EditorCasillasState extends State<EditorCasillas> {
  late TextEditingController _nombre;
  late TextEditingController _cantidad;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.ingrediente.nombre);
    _cantidad = TextEditingController(text: widget.ingrediente.cantidad);
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
    // Este cambio hará que el StreamBuilder se refresque
    widget.actualiza();
  }

  void cambioCantidad(String cantidad) {
    // Este cambio afecta al objeto comida, realmente...
    widget.ingrediente.cantidad = cantidad;
    // Este cambio hará que el StreamBuilder se refresque
    widget.actualiza();
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
                decoration: InputDecoration(
                  hintText: widget.ingrediente.nombre,
                  border: const OutlineInputBorder(),
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
                decoration: InputDecoration(
                  hintText: widget.ingrediente.cantidad,
                  border: const OutlineInputBorder(),
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
    required this.actualiza,
  }) : super(key: key);

  @override
  State<Desplegable> createState() => _DesplegableState();
  final Comida comida;
  final Function actualiza;
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
    widget.comida.tipo = dropdownValue;
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
          widget.actualiza();
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
