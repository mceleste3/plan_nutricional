import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../clases/calendario.dart';
import '../clases/comidas.dart';
import '../clases/extras.dart';

class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    DateTime today = DateTime.now();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 13,
                bottom: 6,
              ),
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Icon(
                  Icons.logout,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          "${today.day}-${today.month}-${today.year}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
          child: Container(
            height: 150,
            width: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 221, 221, 221)),
            child: SingleChildScrollView(child: ExtrasProgramados(id: userid)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 20),
          child: Container(
            height: 340,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 221, 221, 221),
            ),
            child: MenuDia(id: userid),
          ),
        )
      ],
    );
  }
}

class MenuDia extends StatelessWidget {
  const MenuDia({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  List<Comida> menuHoy(List<String> comidasId, List<Comida> comidas) {
    List<Comida> comidasMenu = [];
    for (int j = 0; j < comidasId.length; j++) {
      for (int i = 0; i < comidas.length; i++) {
        if (comidasId[j] == comidas[i].id) {
          comidasMenu.add(comidas[i]);
        }
      }
    }
    return comidasMenu;
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return StreamBuilder(
      stream: calendarioListSnapshots(id),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Calendario>> snapshot,
      ) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final menus = snapshot.data!;

        if (menus.isEmpty) {
          return const Center(
            child: Text("No hay un menú asignado para hoy"),
          );
        }

        List<String> tipoComidas = [];
        List<String> comidasMenu = [];

        for (int i = 0; i < menus.length; i++) {
          if (menus[i].fecha == today) {
            for (var tipo in menus[i].franjas.keys) {
              tipoComidas.add("$tipo"); //debugPrint(comidasMenu);
            }
            for (var comida in menus[i].franjas.values) {
              comidasMenu.add(comida);
            }
          }
        }
        return StreamBuilder(
          stream: comidaListSnapshots(id),
          builder: (BuildContext context, AsyncSnapshot<List<Comida>> snapshot) {
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

            List<Comida> comidasM = menuHoy(comidasMenu, comidas);
            if (comidas.isEmpty) {
              return const Text('No hay ningún menú programando para hoy');
            } else {
              return ListView.builder(
                itemCount: comidasM.length,
                itemBuilder: (context, index) {
                  final comida = comidasM[index];
                  return ComidaWidget(comida: comida, tipo: tipoComidas, index: index);
                },
              );
            }
          },
        );
      },
    );
  }
}

class ComidaWidget extends StatelessWidget {
  const ComidaWidget({Key? key, required this.comida, required this.tipo, required this.index})
      : super(key: key);

  final Comida comida;
  final List<String> tipo;
  final int index;
  static const TextStyle titleStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);
  static const TextStyle subtitleStyle =
      TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 13);
  static const TextStyle ingredientStyle = TextStyle(color: Colors.black, fontSize: 13);

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
            tipo[index].toUpperCase(),
            style: subtitleStyle,
          ),
          Text(
            comida.nombre,
            style: titleStyle,
          ),
          Text("Carbohidrato: ${comida.carbohidrato.join(", ")}", style: ingredientStyle),
          Text(
            "Proteína: ${comida.proteina.join(", ")}",
            style: ingredientStyle,
          ),
          Text(
            "Grasa: ${comida.grasa.join(", ")}",
            style: ingredientStyle,
          ),
        ],
      ),
    );
  }
}

class ExtrasProgramados extends StatelessWidget {
  const ExtrasProgramados({Key? key, required this.id}) : super(key: key);
  final String id;
  List<Extra> extrasHoy(List<Extra> extras, DateTime today) {
    List<Extra> extrashoy = [];
    for (int i = 0; i < extras.length; i++) {
      if (extras[i].repeticion.toUpperCase() == 'SEMANAL') {
        for (int j = 0; j < extras[i].dias!.length; j++) {
          if (extras[i].dias![j] == today) {
            extrashoy.add(extras[i]);
          }
        }
      }
      if (extras[i].repeticion.toUpperCase() == 'DIARIA') {
        extrashoy.add(extras[i]);
      }
    }
    return extrashoy;
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
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
        List<Extra> extrasdeHoy = extrasHoy(extras, today);

        if (extras.isEmpty) {
          return Container(
            height: 150,
            width: 340,
            color: Colors.black26,
            child: const Center(child: Text("No hay suplementos/medicamentos programados")),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: extrasdeHoy.length,
              itemBuilder: (context, index) {
                if (extrasdeHoy[index].repeticion.toLowerCase() == "semanal") {
                  return ListTile(
                    title: Text(
                      "- ${extrasdeHoy[index].nombre.toUpperCase()}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      "  Cantidad: ${extrasdeHoy[index].cantidad}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                } else if (extrasdeHoy[index].repeticion.toLowerCase() == "diaria") {
                  String horas = "";
                  return ListTile(
                    title: Text(
                      "- ${extrasdeHoy[index].nombre.toUpperCase()}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      "  Horas: $horas",
                      style: const TextStyle(fontSize: 15),
                    ), //poner la lista de horas
                  );
                } else if (extrasdeHoy[index].repeticion.toLowerCase() == "") {
                  return const Text('No hay suplementos/medicamentos programados');
                } else {
                  return const Text('No hay suplementos/medicamentos programados');
                }
              }),
        );
      },
    );
  }
}
