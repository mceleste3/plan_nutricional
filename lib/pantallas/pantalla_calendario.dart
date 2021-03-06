import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plan_nutricional/clases/comidas.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:plan_nutricional/clases/calendario.dart';

class PantallaCalendario extends StatefulWidget {
  const PantallaCalendario({Key? key}) : super(key: key);

  @override
  State<PantallaCalendario> createState() => _PantallaCalendarioState();
}

class _PantallaCalendarioState extends State<PantallaCalendario> {
  final user = FirebaseAuth.instance.currentUser!;
  DateTime daySelected = DateTime.now();

  seleccionMenu(List<Comida> comidas) async {
    final menuDia = await cargaCalendario(user.uid, daySelected);

    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 116, 115, 115),
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Desayuno',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Desplegable(
                    comidas: comidas,
                    seleccionInicial: menuDia.franjas[FranjaHoraria.desayuno],
                    onChanged: (String? idComida) {
                      if (idComida == null) {
                        menuDia.franjas.remove(FranjaHoraria.desayuno);
                      } else {
                        menuDia.franjas[FranjaHoraria.desayuno] = idComida;
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Snack',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Desplegable(
                    comidas: comidas,
                    seleccionInicial: menuDia.franjas[FranjaHoraria.snack],
                    onChanged: (String? idComida) {
                      if (idComida == null) {
                        menuDia.franjas.remove(FranjaHoraria.snack);
                      } else {
                        menuDia.franjas[FranjaHoraria.snack] = idComida;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Almuerzo',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Desplegable(
                    comidas: comidas,
                    seleccionInicial: menuDia.franjas[FranjaHoraria.almuerzo],
                    onChanged: (String? idComida) {
                      if (idComida == null) {
                        menuDia.franjas.remove(FranjaHoraria.almuerzo);
                      } else {
                        menuDia.franjas[FranjaHoraria.almuerzo] = idComida;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Merienda',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  Desplegable(
                    comidas: comidas,
                    seleccionInicial: menuDia.franjas[FranjaHoraria.merienda],
                    onChanged: (String? idComida) {
                      if (idComida == null) {
                        menuDia.franjas.remove(FranjaHoraria.merienda);
                      } else {
                        menuDia.franjas[FranjaHoraria.merienda] = idComida;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Cena',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  Desplegable(
                    comidas: comidas,
                    seleccionInicial: menuDia.franjas[FranjaHoraria.cena],
                    onChanged: (String? idComida) {
                      if (idComida == null) {
                        menuDia.franjas.remove(FranjaHoraria.cena);
                      } else {
                        menuDia.franjas[FranjaHoraria.cena] = idComida;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _guardarPulsado(menuDia, user.uid);
              },
              child: const Text(
                "Guardar",
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
  }

  Future<void> _guardarPulsado(Calendario c, String usuarioid) async {
    addCalendario(usuarioid, c);
    // debugPrint('Dia ${c.fecha.day}, ${c.franjas}');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: comidaListSnapshots(user.uid),
        builder: (BuildContext context, AsyncSnapshot<List<Comida>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final comidas = snapshot.data!;
          return Padding(
            padding:
                const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 25),
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(224, 212, 250, 1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color.fromARGB(255, 166, 98, 178)),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              color: Color.fromARGB(139, 92, 18, 145),
                            ),
                          ]),
                      child: TableCalendar(
                        //  formatButtonVisible: false,
                        calendarFormat: CalendarFormat.month,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2100, 3, 14),
                        focusedDay: daySelected,
                        currentDay: daySelected,
                        onDaySelected: (DateTime selected, DateTime focused) {
                          setState(() {
                            daySelected = selected;
                          });
                        },
                        eventLoader: (DateTime date) {
                          final fixedDate = DateTime(2022, 5, 17);
                          // debugPrint("$date $fixedDate");
                          if (date.year == fixedDate.year &&
                              date.month == fixedDate.month &&
                              date.day == fixedDate.day) {
                            return ["hola"];
                          }
                          return [];
                        },
                      ),
                    ),
                  ),
                ),
                // Text("$daySelected"),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      ZonaBoton(
                        text: 'Selecci??n \n      del \n   men??',
                        child: Boton(
                          icon: Icons.edit,
                          onPressed: () => seleccionMenu(comidas),
                        ),
                      ),
                      ZonaBoton(
                        text: '  Programar \n medicaci??n y\n suplementos',
                        child: Boton(
                          icon: Icons.medication,
                          onPressed: () {
                            Navigator.of(context).pushNamed('/programar');
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class Desplegable extends StatefulWidget {
  const Desplegable({
    Key? key,
    required this.comidas,
    required this.seleccionInicial,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<Desplegable> createState() => _DesplegableState();
  final List<Comida> comidas;
  final String? seleccionInicial;
  final void Function(String?) onChanged;
}

class _DesplegableState extends State<Desplegable> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.seleccionInicial;
  }

  List<DropdownMenuItem<String?>> calculaValoresPosibles() {
    return [
      for (int i = 0; i < widget.comidas.length; i++)
        DropdownMenuItem<String>(
          value: widget.comidas[i].id,
          child: Text(widget.comidas[i].nombre.length < 20
              ? widget.comidas[i].nombre
              : widget.comidas[i].nombre.substring(0, 20)),
        ),
      const DropdownMenuItem<String>(
        value: null,
        child: Text('ninguno'),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: dropdownValue,
      items: calculaValoresPosibles(),
      onChanged: (String? selectedValue) {
        widget.onChanged(selectedValue);
        setState(() {
          dropdownValue = selectedValue;
          //widget.idComida = selectedValue;
        });
        //debugPrint("Ha cambiado el valor a $selectedValue");
      },
    );
  }
}

class ZonaBoton extends StatelessWidget {
  const ZonaBoton({
    Key? key,
    required this.text,
    required this.child,
  }) : super(key: key);

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      child: Column(
        children: [
          Center(child: Text(text, style: const TextStyle(fontSize: 14))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ],
      ),
    );
  }
}

class Boton extends StatelessWidget {
  const Boton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(icon),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(50, 33),
      ),
    );
  }
}
