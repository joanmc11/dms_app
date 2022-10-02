import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dms_app/models/player_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
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

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot<Object?>> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }
}
