import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dms_app/models/player_model.dart';
import 'package:dms_app/service/firebase_service.dart';

class DataServices {
  final db = FirebaseFirestore.instance;
  Stream<List<PlayerModel>> playersList() => FirebaseService().collectionStream(
      path: "players",
      builder: (data, documentId) => PlayerModel.fromMap(data, documentId));
}
