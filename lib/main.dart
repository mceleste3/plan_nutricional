import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plan_nutricional/clases/comidas.dart';
import 'package:plan_nutricional/pantallas/pantalla_comidas1.dart';
import 'firebase_options.dart';

final comi1 = Comida.r('desayuno', 'Avena con leche de almendras', [
  Ingrediente('Avena', '30'),
  Ingrediente('Leche de almendras', '30 ml'),
], [
  Ingrediente('huevo', '1'),
  Ingrediente('claras de huevo', '3'),
], [
  Ingrediente('crema de cacahuete', '1 cucharada'),
]);

final comi2 = Comida.r(
  'almuerzo',
  'Pollo con arroz',
  [
    Ingrediente('Arroz', '50 g'),
    Ingrediente('ensalada', '40 g'),
  ],
  [
    Ingrediente('Pollo', '100 g'),
  ],
  [
    Ingrediente('crema de cacahuete ', '1 cucharada'),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NutritionApp());
}

final List<Comida> listaComida = [
  comi1,
  comi2,
  comi2,
  comi2,
  comi2,
  comi2,
  comi2,
  comi2,
  comi2,
  comi2,
  comi1,
  comi2,
  comi2,
  comi1,
  comi1,
  comi1,
  comi1,
  comi1
];

class NutritionApp extends StatelessWidget {
  const NutritionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nutritional Plain',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: PantallaComidas(
        listaComida: listaComida,
      ),
      /*Scaffold(
        body: FutureBuilder(
          future: FirebaseFirestore.instance.doc("/usuarios/xWEDD9TJRiBiizMSSgbN").get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.data!;
            return Center(child: Text(data['nombre']));
          },
        ),
      ),*/
    );
  }
}
