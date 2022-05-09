import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plan_nutricional/pantallas/add_comida.dart';
import 'package:plan_nutricional/pantallas/barra_navegacion.dart';
import 'package:plan_nutricional/pantallas/editar_comida.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nutritional Plan',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const BarraNavegacion(),
      routes: {
        '/agregar': (context) => const AddComida(),
        '/editar': (context) => const EditarComida(),
      },
    );
  }
}
