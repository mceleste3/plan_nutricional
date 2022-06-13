import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser!;
    //final userid = user.uid;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 13,
                  bottom: 20,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Icon(
                    Icons.logout,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 150,
            width: 340,
            color: Colors.black26,
            child: const Center(child: Text("Notificaciones importantes")),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
            child: Container(
              height: 330,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black26,
              ),
              child:
                  const Center(child: Text("Menú seleccionado para ese día")),
              //TODO : Mostrar solo menú (de la lista de menús) coincida con el dia actual (calendario.fecha)
            ),
          )
        ],
      ),
    );
  }
}
