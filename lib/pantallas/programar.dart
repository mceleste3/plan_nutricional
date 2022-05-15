import 'package:flutter/material.dart';
import 'package:plan_nutricional/pantallas/stock_extras.dart';

class Programar extends StatefulWidget {
  const Programar({Key? key}) : super(key: key);

  @override
  State<Programar> createState() => _ProgramarState();
}

class _ProgramarState extends State<Programar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programación')),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
