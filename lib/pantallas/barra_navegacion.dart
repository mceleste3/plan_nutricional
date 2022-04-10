import 'package:flutter/material.dart';
import 'package:plan_nutricional/pantallas/pantalla_comidas.dart';
import 'package:plan_nutricional/pantallas/perfil.dart';

class BarraNavegacion extends StatefulWidget {
  const BarraNavegacion({Key? key}) : super(key: key);
  @override
  State<BarraNavegacion> createState() => _BarraNavegacionState();
}

class _BarraNavegacionState extends State<BarraNavegacion> {
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
    Container(
      color: Colors.white,
    ),
    Container(
      color: Colors.white,
    ),
    Container(
      color: Colors.white,
    ),
    const Perfil(),
  ];
  @override
  void initState() {
    _paginaActual = 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text(
          "${titulos.elementAt(_paginaActual)}",
          style: const TextStyle(),
        ),
      )),
      body: _widgetOptions.elementAt(_paginaActual),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        backgroundColor: Colors.teal,
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
