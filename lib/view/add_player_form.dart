import 'dart:io';

import 'package:dms_app/service/firebase_service.dart';
import 'package:dms_app/service/function_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPlayer extends StatefulWidget {
  const AddPlayer({super.key});

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  String imgPath = '';
  File? _image;
  callbackImgPath(varImgPath, varImgFile) {
    setState(() {
      imgPath = varImgPath;
      _image = varImgFile;
    });
  }

  final _formKey = GlobalKey<FormState>();

  bool goalkeeper = false;
  bool jugador = true;
  String pos = 'jugador';

  String name = '';
  String surename = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Añadir Jugador"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Nombre del jugador',
                    labelText: ' Nombre *',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Porfavor introduce un nombre';
                    }
                    setState(() {
                      name = value;
                    });
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Apellido del jugador',
                    labelText: ' Apellido *',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Porfavor introduce un nombre';
                    }
                    setState(() {
                      surename = value;
                    });
                  },
                ),
              ),
              RadioListTile(
                title: const Text("Jugador"),
                value: true,
                groupValue: jugador,
                onChanged: (value) {
                  setState(() {
                    goalkeeper = false;
                    jugador = true;
                  });
                },
              ),
              RadioListTile(
                title: const Text("Portero"),
                value: true,
                groupValue: goalkeeper,
                onChanged: (value) {
                  setState(() {
                    goalkeeper = true;
                    jugador = false;
                  });
                },
              ),
              InkWell(
                onTap: (() {
                  FunctionService().imagenMulta(context, callbackImgPath);
                }),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DottedBorder(
                    radius: const Radius.circular(8),
                    borderType: BorderType.RRect,
                    dashPattern: const [5],
                    color: Colors.blue,
                    strokeWidth: 0.5,
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _image == null
                            ? const Icon(
                                Icons.add_a_photo,
                                size: 80,
                                color: Colors.blue,
                              )
                            : Image.file(_image!),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Jugador Añadido')),
                        );
                        await FirebaseService().addPlayer(
                            name: name,
                            surename: surename,
                            goalkeeper: goalkeeper,
                            imageFile: _image,
                            imagePath: imgPath);
                        Get.back();
                      }
                    },
                    child: const Text("Añadir")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
