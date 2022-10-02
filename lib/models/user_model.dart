

import 'package:dms_app/models/player_model.dart';

class UserModel {

  final String id;
  final bool admin;
  final String name;
  final String avatar;
  final List<PlayerModel>? players;
  final int points;
  final int position;

  UserModel({required this.id, required this.admin, required this.name, this.avatar = "", required this.players, this.points = 0, this.position = 1});


  
}