import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plan_nutricional/pantallas/calendario.dart';
import 'package:plan_nutricional/pantallas/inicio.dart';
import 'package:plan_nutricional/pantallas/pantalla_comidas.dart';
import 'package:plan_nutricional/pantallas/perfil.dart';
import 'package:plan_nutricional/pantallas/stock_extras.dart';

class BarraNavegacion extends StatefulWidget {
  const BarraNavegacion({Key? key}) : super(key: key);
  @override
  State<BarraNavegacion> createState() => _BarraNavegacionState();
}

class _BarraNavegacionState extends State<BarraNavegacion> {
  bool usuarioCreado = false;

  late int _paginaActual;
  static final List<String> titulos = [
    'Comidas',
    'Calendario',
    'Inicio',
    'Stock',
    'Perfil'
  ];
  PageController pageController = PageController();
  /*static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold); */
  static final List<Widget> _widgetOptions = <Widget>[
    const PantallaComidas(),
    const Calendario(),
    const Inicio(),
    const Extras(),
    const Perfil(),
  ];

  Future<void> crearUsuarioSiNoExiste() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.doc("/usuarios/$uid");
    final user = await userRef.get();
    if (!user.exists) {
      // Inicialización del usuario la primera vez
      await userRef.set({
        'nombre': '',
        'apellidos': '',
        'altura': 0,
        'edad': 0,
        'peso': 0,
        'sexo': '',
        'medida1': '',
        'medida2': '',
        'medida3': '',
        'medida4': '',
      });
    }
    setState(() => usuarioCreado = true);
  }

  @override
  void initState() {
    _paginaActual = 2;
    super.initState();
    crearUsuarioSiNoExiste();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Center(
        child: Text(
          titulos.elementAt(_paginaActual),
          style: const TextStyle(),
        ),
      ),
    );

    if (!usuarioCreado) {
      return Scaffold(
        appBar: appBar,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: _widgetOptions.elementAt(_paginaActual),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        backgroundColor: const Color(0xFF009696),
        currentIndex: _paginaActual,
        selectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Comidas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
