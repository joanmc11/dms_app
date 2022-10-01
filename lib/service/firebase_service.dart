import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  Future addPlayer(
      {required String name,
      required String surename,
      String image = '',
      required bool goalkeeper}) async {
    final db = FirebaseFirestore.instance;
    await db.collection('players').add({
      'name': name,
      'surename': surename,
      'points': 0,
      'image': image,
      'goalkeeper': goalkeeper
    });

    image == ''
        ? null
        : await FirebaseStorage.instance
            .ref("/jugadores/$image")
            .putFile(image as File);
  }
}
