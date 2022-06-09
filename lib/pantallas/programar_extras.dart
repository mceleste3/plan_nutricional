import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:day_picker/day_picker.dart';

import '../clases/extras.dart';
import '../clases/usuario.dart';

class Programar extends StatefulWidget {
  const Programar({Key? key}) : super(key: key);

  @override
  State<Programar> createState() => _ProgramarState();
}

class _ProgramarState extends State<Programar> {
  List<DayInWeek> days = [
    DayInWeek(
      "Lunes",
    ),
    DayInWeek(
      "Martes",
    ),
    DayInWeek(
      "Miércoles",
    ),
    DayInWeek(
      "Jueves",
    ),
    DayInWeek(
      "Viernes",
    ),
    DayInWeek(
      "Sábado",
    ),
    DayInWeek("Domingo", isSelected: true),
  ];
  late bool habilitadoDias;
  late bool habilitadoHoras;

  @override
  void initState() {
    super.initState();
    habilitadoDias = false;
    habilitadoHoras = false;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    Extra extra = Extra('', '');
    List<String> diasSeleccionados;
    extra.repeticion = 'diaria';
    extra.horas = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
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
                return const Center(child: Text("No hay extras"));
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 10, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tipo de suplemento/medicación',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Desplegable(
                        extras: extras,
                        extra: extra,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Repetir',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                habilitadoDias = false;
                                habilitadoHoras = true;
                              });
                            },
                            child: const Text(
                              'Dirariamente',
                              style: TextStyle(fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                          ),
                          const SizedBox(
                            width: 45,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                habilitadoDias = true;
                                habilitadoHoras = false;
                              });
                            },
                            child: const Text(
                              'Semanalmente',
                              style: TextStyle(fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SelectorHora(
                        listaHoras: extra.horas,
                        horas: habilitadoHoras,
                        dias: habilitadoDias,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SelectWeekDays(
                        daysFillColor: habilitadoHoras == false && habilitadoDias == true
                            ? Colors.white
                            : const Color.fromARGB(255, 208, 208, 208),
                        daysBorderColor: habilitadoHoras == false && habilitadoDias == true
                            ? Colors.white
                            : const Color.fromARGB(255, 164, 163, 163),
                        onSelect: (value) {
                          if (habilitadoDias == true) {
                            debugPrint('${value.runtimeType}');
                            diasSeleccionados = value;
                          }
                        },
                        days: days,
                        unSelectedDayTextColor: habilitadoHoras == false && habilitadoDias == true
                            ? Colors.white
                            : const Color.fromARGB(255, 164, 163, 163),
                        selectedDayTextColor: habilitadoHoras == false && habilitadoDias == true
                            ? Colors.black
                            : const Color.fromARGB(255, 164, 163, 163),
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: habilitadoHoras == false && habilitadoDias == true
                              ? const Color(0xFF009696)
                              : const Color.fromARGB(255, 208, 208, 208),
                        ),
                        padding: 4,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 200, top: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            // _guardarPulsado(extra);
                          },
                          child: const Text(
                            'Guardar',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SelectorHora extends StatefulWidget {
  const SelectorHora({Key? key, required this.listaHoras, required this.horas, required this.dias})
      : super(key: key);

  final List<TimeOfDay>? listaHoras;
  final bool horas;
  final bool dias;
  @override
  State<SelectorHora> createState() => _SelectorHoraState();
}

class _SelectorHoraState extends State<SelectorHora> {
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);
  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        widget.listaHoras!.add(_time);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Horas: ${widget.horas}, Dias: ${widget.dias}'),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => setState(() {
                if (widget.horas == true && widget.dias == false) {
                  _selectTime();
                } else {
                  null;
                }
              }),
              child: Text(
                'Seleccionar la hora',
                style: TextStyle(
                    color: widget.horas == true && widget.dias == false
                        ? Colors.black
                        : const Color.fromARGB(255, 111, 111, 111)),
              ),
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 2,
                  color: widget.horas == true && widget.dias == false
                      ? const Color.fromARGB(255, 1, 118, 118)
                      : const Color.fromARGB(255, 208, 208, 208),
                ),
                primary: widget.horas == true && widget.dias == false
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 208, 208, 208),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                if (widget.horas == true && widget.dias == false) {
                  if (widget.listaHoras!.isNotEmpty) {
                    widget.listaHoras!.removeLast();
                  }
                } else {
                  null;
                }
              }),
              child: const Icon(Icons.delete),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      width: 2,
                      color: widget.horas == true && widget.dias == false
                          ? const Color.fromARGB(255, 1, 118, 118)
                          : const Color.fromARGB(255, 208, 208, 208),
                    ),
                  ),
                  minimumSize: const Size(50, 33),
                  primary: const Color.fromARGB(255, 255, 255, 255),
                  onPrimary: widget.horas == true && widget.dias == false
                      ? Colors.black
                      : const Color.fromARGB(255, 111, 111, 111)),
            ),
          ],
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.listaHoras!.length,
          itemBuilder: (context, index) {
            debugPrint('longitud: ${widget.listaHoras!.length}');
            return CasillaHora(time: widget.listaHoras![index]);
          },
        ),
      ],
    );
  }
}

class CasillaHora extends StatefulWidget {
  const CasillaHora({Key? key, required TimeOfDay time})
      : _time = time,
        super(key: key);

  final TimeOfDay _time;

  @override
  State<CasillaHora> createState() => _CasillaHoraState();
}

class _CasillaHoraState extends State<CasillaHora> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${widget._time.format(context)}'),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class Desplegable extends StatefulWidget {
  const Desplegable({Key? key, required this.extras, required this.extra}) : super(key: key);

  final List<Extra> extras;
  final Extra extra;

  @override
  State<Desplegable> createState() => _DesplegableState();
}

class _DesplegableState extends State<Desplegable> {
  String? dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.extras[0].nombre;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? repeticion;
    return DropdownButton(
      value: dropdownValue,
      items: [
        for (int i = 0; i < widget.extras.length; i++)
          DropdownMenuItem<String>(
              value: widget.extras[i].nombre,
              child: Text(widget.extras[i].nombre.substring(0, 8)),
              onTap: () {
                //widget.indice = i;
                //debugPrint(
                // "Has seleccionado la comida ${widget.comidas[i].nombre}",
                //);

                repeticion = widget.extras[i].repeticion;
              })
      ],
      onChanged: (String? selectedValue) {
        setState(() {
          dropdownValue = selectedValue!;
          widget.extra.repeticion = repeticion;
          debugPrint(widget.extra.repeticion);
        });
        debugPrint(
          "Ha cambiado el valor a $selectedValue",
        );
      },
    );
  }
}
