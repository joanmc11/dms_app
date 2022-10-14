import 'dart:io';

import 'package:dms_app/controller/login_controller.dart';
import 'package:dms_app/models/liga_model.dart';
import 'package:dms_app/models/user_model.dart';
import 'package:dms_app/service/auth_service.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:dms_app/service/function_service.dart';
import 'package:dms_app/service/user_pref_service.dart';
import 'package:dms_app/service/write_service_database.dart';
import 'package:dms_app/view/add_player_form.dart';
import 'package:dms_app/view/edit_name.dart';
import 'package:dms_app/view/puntuar_jornada.dart';
import 'package:dms_app/widgets/profile_menu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  return StreamBuilder(
                      stream: DataServices().liga(),
                      builder: (BuildContext context,
                          AsyncSnapshot<LigaModel> snapshot) {
                        if (snapshot.hasData) {
                          var jornada = snapshot.data!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _imageWidget(user: user),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.1),
                                    ),
                                    IconButton(onPressed: (){
                                      Get.to( EditName(userName: user.name,));
                                    }, icon: Icon(Icons.edit))
                                  ],
                                ),
                              ),
                              const Padding(
                                padding:
                                    EdgeInsets.only(top: 16.0, bottom: 8.0),
                                child: Text(
                                  "Opciones de Liga",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              ProfileMenu(
                                text: "Añadir jugador",
                                icon: FontAwesomeIcons.user,
                                press: user.admin
                                    ? () => Get.to(() => const AddPlayer())
                                    : () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text('No eres administrador!'),
                                        ));
                                      },
                              ),
                              jornada.jornada
                                  ? ProfileMenu(
                                      text: "Puntuar Jornada",
                                      icon: Icons.sports_soccer_outlined,
                                      press: user.admin
                                          ? (() => Get.to(
                                              () => const PuntuarJornada()))
                                          : () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'No eres administrador!'),
                                              ));
                                            },
                                    )
                                  : const ProfileMenu(
                                      text: "Puntuar Jornada",
                                      icon: Icons.sports_soccer_outlined,
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: ElevatedButton.icon(
                                    onPressed: user.admin
                                        ? () {
                                            _showAlertDialog(context, () async {
                                              await WriteService().startJornada(
                                                  !jornada.jornada);
                                              jornada.jornada
                                                  ? WriteService().endJornada()
                                                  : WriteService().newJornada();
                                              Navigator.pop(context);
                                            }, jornada.jornada);
                                          }
                                        : () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(jornada.mensaje),
                                            ));
                                          },
                                    icon: const FaIcon(Icons.start),
                                    label: Text(jornada.jornada
                                        ? "Finalizar jornada"
                                        : "Empezar jornada")),
                              )
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                AuthService().signOut();
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
              },
              child: const Text("Cerrar Sesión"))
        ],
      ),
    );
  }

  _showAlertDialog(BuildContext context, Function press, bool start) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancelar"),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: const Text("Continuar"),
      onPressed: () => press(),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(start ? "Finalizar jornada" : "Empezar jornada"),
      content: Text(start
          ? "¿Quieres finalizar la jornada?"
          : "¿Quieres empezar la jornada?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class _imageWidget extends StatefulWidget {
  const _imageWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  State<_imageWidget> createState() => _imageWidgetState();
}

class _imageWidgetState extends State<_imageWidget> {
  String imgPath = '';
  File? _image;
  callbackImgPath(varImgPath, varImgFile) {
    setState(() {
      imgPath = varImgPath;
      _image = varImgFile;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(fit: StackFit.loose, children: [
        widget.user.avatar == ''
            ? CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.18,
                child: FaIcon(
                  FontAwesomeIcons.userLarge,
                  size: MediaQuery.of(context).size.width * 0.15,
                ),
              )
            : FutureBuilder(
                future: FirebaseStorage.instance
                    .ref(widget.user.avatar)
                    .getDownloadURL(),
                builder: (context, AsyncSnapshot<String> snapshot) {
                  debugPrint(snapshot.data);
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                 
                  return CircleAvatar(
                     radius: MediaQuery.of(context).size.width * 0.18,
                    child: CircleAvatar(
                      maxRadius:  MediaQuery.of(context).size.width * 0.18,
                      backgroundImage: NetworkImage(snapshot.data!),
                    ),
                  );
                }),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.25,
          left: MediaQuery.of(context).size.width * 0.20,
          child: IconButton(
              onPressed: () async {
                await FunctionService().imagenMulta(context, callbackImgPath);

                if (imgPath != '') {
                 await WriteService()
                      .updateUserImage(imagePath: imgPath, imageFile: _image);
                }
                setState(() {
                  
                });
              },
              icon:  Icon(
                Icons.add_a_photo,
                size: 40,
                color: widget.user.avatar=='' ? Colors.black : Colors.red,
              )),
        )
      ]),
    );
  }
}
