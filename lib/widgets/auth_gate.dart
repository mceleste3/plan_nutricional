import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:plan_nutricional/clases/usuario.dart';
//import { doc, setDoc } from "firebase/firestore";

class AuthGate extends StatelessWidget {
  final Widget app;
  const AuthGate({Key? key, required this.app}) : super(key: key);

  /*Future<void> _usuarioNuevo() async {
    final user = Usuario('');
    final u = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;
    await setDoc(doc(db, "usuario", "${u.uid}"), data);
  }*/

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: SignInScreen(
              providerConfigs: [
                EmailProviderConfiguration(),
              ],
            ),
          );
        }
        //  _usuarioNuevo();
        return app;
      },
    );
  }
}
