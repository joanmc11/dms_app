import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dms_app/models/player_model.dart';
import 'package:dms_app/models/user_model.dart';
import 'package:dms_app/service/firebase_service.dart';

class DataServices {
  final db = FirebaseFirestore.instance;
  Stream<List<PlayerModel>> playersList() => FirebaseService().collectionStream(
      path: "players",
      builder: (data, documentId) => PlayerModel.fromMap(data, documentId));


  Stream<List<UserModel>> userList() => FirebaseService().collectionStream(
      path: "users",
      queryBuilder: (query) => query.orderBy('points', descending: true),
      builder: (data, documentId) => UserModel.fromMap(data, documentId));
}
