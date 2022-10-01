import 'package:dms_app/view/add_player_form.dart';
import 'package:dms_app/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.18,
                child: FaIcon(
                  FontAwesomeIcons.userLarge,
                  size: MediaQuery.of(context).size.width * 0.15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Joan",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.1),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                "Opciones de Liga",
                style: TextStyle(fontSize: 18),
              ),
            ),
            ProfileMenu(
              text: "Añadir jugador",
              icon: FontAwesomeIcons.user,
              press: () {
                Get.to(()=>AddPlayer());
              },
            ),
            const ProfileMenu(
                text: "Puntuar Jornada", icon: Icons.sports_soccer_outlined),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const FaIcon(Icons.start),
                  label: const Text("Empezar jornada")),
            ),
          ],
        ),
      ),
    );
  }
}
