import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plan_nutricional/pantallas/add_comida.dart';
import 'package:plan_nutricional/pantallas/barra_navegacion.dart';
import 'package:plan_nutricional/pantallas/editar_comida.dart';
import 'package:plan_nutricional/pantallas/programar_extras.dart';
import 'package:plan_nutricional/widgets/auth_gate.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const AuthGate(
      app: NutritionApp(),
    ),
  );
}

class NutritionApp extends StatelessWidget {
  const NutritionApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = const {
      50: Color(0xFF183A3C),
      100: Color(0x3342FFFF),
      200: Color(0x4942FFFF),
      300: Color(0x6642FFFF),
      400: Color(0x7C42D6FF),
      500: Color(0x9942FFFF),
      600: Color(0xAF42FFFF),
      700: Color(0xCC42FFFF),
      800: Color(0xE442FFFF),
      900: Color(0xFF009696)
    };
    MaterialColor colorCustom = MaterialColor(0xFF009696, color);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nutritional Plan',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: const BarraNavegacion(),
      routes: {
        '/agregar': (context) => const AddComida(),
        '/editar': (context) => const EditarComida(),
        '/programar': (context) => const Programar(),
      },
    );
  }
}
