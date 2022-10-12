import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dms_app/controller/login_controller.dart';
import 'package:dms_app/controller/navigation_controller.dart';
import 'package:dms_app/service/user_pref_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class WriteService{

  final db = FirebaseFirestore.instance;
  Future addPlayer(
      {required String name,
      required String surename,
      String imagePath = 'sinpath',
      File? imageFile,
      required bool goalkeeper}) async {
    await db.collection('players').add({
      'name': name,
      'surename': surename,
      'points': 0,
      'image': 'jugadores/$imagePath',
      'goalkeeper': goalkeeper
    });

    imagePath == ''
        ? null
        : await FirebaseStorage.instance
            .ref()
            .child('jugadores/$imagePath')
            .putFile(imageFile!);
  }
  
  Future updateUserdata(String nombre, String uid) async {
     LoginController logController  =
      Get.put(LoginController());
      logController.setId(uid);
    final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
    return await userCollection.doc(uid).set({
      'name': nombre,
      'id': uid,
      'points': 0,
      'position': 1,
      'admin':false,
      'avatar':''
    });
  }

  //Update user players
  Future updateUserPlayers(String playerId, position) async {
     UserPreferences prefs = UserPreferences();
    final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
    return await userCollection.doc(prefs.uid).update({
      '$position': playerId,
    });
  }
}