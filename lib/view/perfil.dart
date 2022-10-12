import 'package:dms_app/controller/login_controller.dart';
import 'package:dms_app/models/user_model.dart';
import 'package:dms_app/service/auth_service.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:dms_app/service/user_pref_service.dart';
import 'package:dms_app/view/add_player_form.dart';
import 'package:dms_app/view/puntuar_jornada.dart';
import 'package:dms_app/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    var prefs = UserPreferences();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: StreamBuilder(
              stream: DataServices().userInfo(prefs.uid),
              builder:
                  (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                if (snapshot.hasData) {
                  var user = snapshot.data!;
                  return Column(
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
                          user.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.1),
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
                        press: () => Get.to(() => const AddPlayer()),
                      ),
                      ProfileMenu(
                        text: "Puntuar Jornada",
                        icon: Icons.sports_soccer_outlined,
                        press: (() => Get.to(() => PuntuarJornada())),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const FaIcon(Icons.start),
                            label: const Text("Empezar jornada")),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          ElevatedButton(
              onPressed: () => AuthService().signOut(),
              child: const Text("Cerrar Sesión"))
        ],
      ),
    );
  }
}
