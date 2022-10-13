import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dms_app/controller/login_controller.dart';
import 'package:dms_app/controller/navigation_controller.dart';
import 'package:dms_app/service/user_pref_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class WriteService {
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
    LoginController logController = Get.put(LoginController());
    logController.setId(uid);
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    return await userCollection.doc(uid).set({
      'name': nombre,
      'id': uid,
      'points': 0,
      'position': 1,
      'admin': false,
      'avatar': ''
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

  //Update points player
  Future updatePointsPlayer(String playerId, bool yellowCard, bool redCard,
      bool mvp, int goals, bool win, int currentPoints) async {
    int points = 0;
    int yellow = yellowCard ? -1 : 0;
    int red = redCard ? -4 : 0;
    int bestPlayer = mvp ? (win ? 4 : 3) : 0;
    int goalsGame = goals * (win ? 4 : 2);
    points = yellow + red + bestPlayer + goalsGame;

    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('players');
    return await userCollection
        .doc(playerId)
        .update({'points': currentPoints + points, 'jornada': points});
  }

   Future updatePointsGoalkeeper(String playerId, bool yellowCard, bool redCard,
      bool mvp, int goals, bool win, int currentPoints, int scoreGoal) async {
    int points = 0;
    int yellow = yellowCard ? -1 : 0;
    int red = redCard ? -4 : 0;
    int bestPlayer = mvp ? (win ? 5 : 3) : 0;
    int goalsGame = goals * (win ? -1 : -2);
    points = yellow + red + bestPlayer + goalsGame + scoreGoal*6;


    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('players');
    return await userCollection
        .doc(playerId)
        .update({'points': currentPoints + points, 'jornada': points});
  }
}
