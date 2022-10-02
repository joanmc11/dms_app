
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class FunctionService {

  Future imagenMulta(context, callbackImgPath, ) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text(
                "Imagen del jugador",
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  onPressed: () async {
                    final image = await ImagePicker().pickImage(
                        source: ImageSource.camera, imageQuality: 10);
                    if (image == null) return;

                    final imageFile = File(image.path);
                    

                   await callbackImgPath(image.name, imageFile);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.camera),
                      Text("Camera"),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final image = await ImagePicker().pickImage(
                        source: ImageSource.gallery, imageQuality: 10);
                    if (image == null) return;

                    final imageFile = File(image.path);
                  

                    await callbackImgPath(image.name, imageFile);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.image),
                      Text("Galeria"),
                    ],
                  ),
                ),
              ],
            ),
        barrierDismissible: true);
  }
}