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
    DayInWeek("Lunes"),
    DayInWeek("Martes"),
    DayInWeek("Miércoles"),
    DayInWeek("Jueves"),
    DayInWeek("Viernes"),
    DayInWeek("Sábado"),
    DayInWeek("Domingo", isSelected: true),
  ];
  late bool habilitadoDias;
  late bool habilitadoHoras;

  Extra extra = Extra('', '');
  List<String> diasSeleccionados = [];
  String? idExtra;

  @override
  void initState() {
    super.initState();
    habilitadoDias = false;
    habilitadoHoras = false;
    extra.repeticion = 'diaria';
    extra.horas = [];
  }

  List<DateTime> calcularDiasParaCalendario(
      String dia, DateTime inicio, DateTime fin) {
    List<DateTime> days = [];
    //Intervalo de fechas para generar una lista con los días de la semana seleccionados
    for (DateTime d = inicio;
        d.isBefore(fin);
        d = d.add(const Duration(days: 1))) {
      int i = 0;
      switch (dia) {
        //Calcula el número del día de la semana
        case 'Lunes':
          i = 1;
          break;
        case 'Martes':
          i = 2;
          break;
        case 'Miércoles':
          i = 3;
          break;
        case 'Jueves':
          i = 4;
          break;
        case 'Viernes':
          i = 5;
          break;
        case 'Sábado':
          i = 6;
          break;
        case 'Domingo':
          i = 7;
          break;
      }
      if (d.weekday == i) {
        days.add(d);
      }
    }
    return days;
  }

  Future<void> _guardarPulsado(
    String usuarioId,
    Extra e,
    List<String> dias,
  ) async {
    final DateTime inicio = DateTime.now();
    final DateTime fin = DateTime.utc(2022, 7, 20);
    if (habilitadoDias == false && habilitadoHoras == true) {
      e.repeticion = 'Diariamente';
    } else {
      e.repeticion = 'Semanalmente';
      e.dias = [];
      //Se necesita transferir los días de la lista String a una lista de fechas en el calendario (DateTime)
      for (int i = 0; i < dias.length; i++) {
        e.dias!.addAll(calcularDiasParaCalendario(dias[i], inicio, fin));
      }
    }
    updateExtra(usuarioId, e);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;

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
              final listaExtras = snapshot.data!;

              if (listaExtras.isEmpty) {
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Desplegable(
                          extras: listaExtras,
                          onChanged: (String? id) {
                            extra.id = id;
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Repetir',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15)),
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
                              'Semanalmente ',
                              style: TextStyle(fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SelectorHora(
                        extra: extra,
                        horas: habilitadoHoras,
                        dias: habilitadoDias,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SelectWeekDays(
                        daysFillColor:
                            habilitadoHoras == false && habilitadoDias == true
                                ? Colors.white
                                : const Color.fromARGB(255, 208, 208, 208),
                        daysBorderColor:
                            habilitadoHoras == false && habilitadoDias == true
                                ? Colors.white
                                : const Color.fromARGB(255, 164, 163, 163),
                        onSelect: (value) {
                          if (habilitadoDias == true) {
                            debugPrint('${value.runtimeType}');
                            diasSeleccionados = value;
                          }
                        },
                        days: days,
                        unSelectedDayTextColor:
                            habilitadoHoras == false && habilitadoDias == true
                                ? Colors.white
                                : const Color.fromARGB(255, 164, 163, 163),
                        selectedDayTextColor:
                            habilitadoHoras == false && habilitadoDias == true
                                ? Colors.black
                                : const Color.fromARGB(255, 164, 163, 163),
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color:
                              habilitadoHoras == false && habilitadoDias == true
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
                            for (final e in listaExtras) {
                              if (e.id == extra.id) {
                                extra.cantidad = e.cantidad;
                                extra.nombre = e.nombre;
                              }
                            }
                            debugPrint(
                                'Valores $idExtra `` funcion guardar ${extra.id}, ${extra.cantidad}, ${extra.nombre}');
                            _guardarPulsado(userid, extra, diasSeleccionados);
                          },
                          child: const Text(
                            'Guardar',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15)),
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
  const SelectorHora(
      {Key? key, required this.extra, required this.horas, required this.dias})
      : super(key: key);

  final Extra extra;
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
        widget.extra.horas!.add(_time);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('Horas: ${widget.horas}, Dias: ${widget.dias}'),
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
                  if (widget.extra.horas!.isNotEmpty) {
                    widget.extra.horas!.removeLast();
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
          itemCount: widget.extra.horas!.length,
          itemBuilder: (context, index) {
            debugPrint('longitud: ${widget.extra.horas!.length}');
            return CasillaHora(time: widget.extra.horas![index]);
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
            child: Text(widget._time.format(context)),
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
  const Desplegable({
    Key? key,
    required this.extras,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<Desplegable> createState() => _DesplegableState();
  final List<Extra> extras;
  final void Function(String?) onChanged;
}

class _DesplegableState extends State<Desplegable> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownValue,
      items: [
        for (int i = 0; i < widget.extras.length; i++)
          DropdownMenuItem<String>(
            value: widget.extras[i].id,
            child: Text(widget.extras[i].nombre /*.substring(0, 8)*/),
          )
      ],
      onChanged: (String? selectedValue) {
        widget.onChanged(selectedValue);
        setState(() {
          dropdownValue = selectedValue!;
        });
        debugPrint(
          "Ha cambiado el valor a $selectedValue",
        );
      },
    );
  }
}
