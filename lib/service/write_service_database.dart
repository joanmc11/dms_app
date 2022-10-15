import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dms_app/controller/login_controller.dart';
import 'package:dms_app/service/user_pref_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
      'image': imagePath == '' ? '' : 'jugadores/$imagePath',
      'goalkeeper': goalkeeper,
      'jornada': 0,
      'jornadaList': [],
      'punctuated': false
    });

    imagePath == ''
        ? null
        : await FirebaseStorage.instance
            .ref()
            .child('jugadores/$imagePath')
            .putFile(imageFile!);
  }

  //Update user image
  Future updateUserImage({
    String imagePath = 'sinpath',
    File? imageFile,
  }) async {
    UserPreferences prefs = UserPreferences();
    await db.collection('users').doc(prefs.uid).update({
      'avatar': 'usuarios/$imagePath',
    });

    imagePath == ''
        ? null
        : await FirebaseStorage.instance
            .ref()
            .child('usuarios/$imagePath')
            .putFile(imageFile!);
  }

  Future updateUserName({required String name}) async {
    UserPreferences prefs = UserPreferences();
    await db.collection('users').doc(prefs.uid).update({
      'name': name,
    });
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
      'avatar': '',
      'jornada': 0,
      'pivot': '',
      'alaIzq': '',
      'alaDer': '',
      'cierre': '',
      'portero': '',
      'jornadaList': []
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
    //Get Jornadas
    Future<List<dynamic>> getJornadas() async {
      final docRef =
          FirebaseFirestore.instance.collection('players').doc(playerId);
      var snapshot = await docRef.get();
      if (snapshot.exists) {
        return await snapshot.data()!['jornadaList'];
      } else {
        return [];
      }
    }

    int points = 0;
    int yellow = yellowCard ? -1 : 0;
    int red = redCard ? -4 : 0;
    int bestPlayer = mvp ? (win ? 4 : 3) : 0;
    int goalsGame = goals * (win ? 4 : 2);
    points = yellow + red + bestPlayer + goalsGame;

    List<dynamic> listaJornadas = await getJornadas();
    listaJornadas.add(points);

    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('players');
    return await userCollection.doc(playerId).update({
      'points': currentPoints + points,
      'jornada': points,
      'jornadaList': listaJornadas
    });
  }

  Future updatePointsGoalkeeper(String playerId, bool yellowCard, bool redCard,
      bool mvp, int goals, bool win, int currentPoints, int scoreGoal) async {
    //Get Jornadas
    Future<List<dynamic>> getJornadas() async {
      final docRef =
          FirebaseFirestore.instance.collection('players').doc(playerId);
      var snapshot = await docRef.get();
      if (snapshot.exists) {
        return await snapshot.data()!['jornadaList'];
      } else {
        return [];
      }
    }

    int points = 0;
    int yellow = yellowCard ? -1 : 0;
    int red = redCard ? -4 : 0;
    int bestPlayer = mvp ? (win ? 5 : 3) : 0;
    int goalsGame = goals * (win ? -1 : -2);
    points = yellow + red + bestPlayer + goalsGame + scoreGoal * 6;

    List<dynamic> listaJornadas = await getJornadas();
    listaJornadas.add(points);

    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('players');
    return await userCollection.doc(playerId).update({
      'points': currentPoints + points,
      'jornada': points,
      'jornadaList': listaJornadas
    });
  }

  //Toggle jornada
  Future startJornada(bool start) async {
    final CollectionReference ligaCollection =
        FirebaseFirestore.instance.collection('liga');
    return await ligaCollection.doc('liga').update({
      'jornada': start,
    });
  }

  //Empezar jornada y resetear puntos
  Future newJornada() async {
    FirebaseFirestore.instance.collection('players').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.update({
          'jornada': 0, //Reset jornada
          'punctuated': false //Reset jornada
        });
      }
    });
  }

  //Jugador ha sido puntuado
  Future checkPlayer(String playerId) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('players');
    return await userCollection.doc(playerId).update({'punctuated': true});
  }

  //Finalizar jornada
  Future endJornada() async {
    //Get player points

    Future<int> getPoints(String playerId) async {
      final docRef =
          FirebaseFirestore.instance.collection('players').doc(playerId);
      var snapshot = await docRef.get();
      if (snapshot.exists) {
        return snapshot.data()!['jornada'];
      } else {
        return 0;
      }
    }

    //Get Jornadas
    Future<List<dynamic>> getJornadas(String userId) async {
      final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
      var snapshot = await docRef.get();
      if (snapshot.exists) {
        return await snapshot.data()!['jornadaList'];
      } else {
        return [];
      }
    }

    FirebaseFirestore.instance.collection('users').get().then((snapshot) async {
      for (DocumentSnapshot ds in snapshot.docs) {
        int points = (ds.get('pivot') != null
                ? await getPoints(
                    ds.get('pivot') == '' ? 'sinid' : ds.get('pivot'))
                : 0) +
            (ds.get('cierre') != null
                ? await getPoints(
                    ds.get('cierre') == '' ? 'sinid' : ds.get('cierre'))
                : 0) +
            (ds.get('alaIzq') != null
                ? await getPoints(
                    ds.get('alaIzq') == '' ? 'sinid' : ds.get('alaIzq'))
                : 0) +
            (ds.get('alaDer') != null
                ? await getPoints(
                    ds.get('alaDer') == '' ? 'sinid' : ds.get('alaDer'))
                : 0) +
            (ds.get('portero') != null
                ? await getPoints(
                    ds.get('portero') == '' ? 'sinid' : ds.get('portero'))
                : 0);

        List<dynamic> listaJornadas = await getJornadas(ds.get('id'));
        listaJornadas.add(points);

        ds.reference.update({
          'jornada': points, //Reset jornada
          'points': points + ds.get('points'),
          'jornadaList': listaJornadas
        });
      }
    });
  }
}
