import 'package:dms_app/models/player_model.dart';

class UserModel {
  final String id;
  final bool admin;
  final String name;
  final String avatar;
  final String? pivot;
  final String? alaIzq;
  final String? alaDer;
  final String? cierre;
  final String? portero;
  final int points;
  final int position;
  final int jornada;

  UserModel(
      {this.pivot,
      this.alaIzq,
      this.alaDer,
      this.cierre,
      this.portero,
      required this.id,
      required this.admin,
      required this.name,
      this.avatar = "",
      this.points = 0,
      this.position = 1,
      this.jornada = 0
      });


       UserModel.fromMap(Map snapshot, this.id)
      : 
      name = snapshot['name'],
        admin = snapshot['admin'] ,
        points = snapshot['points'],
        avatar = snapshot['avatar'] ,
        position = snapshot['position'] ?? 1,
        pivot = snapshot['pivot'] ?? "",
        alaIzq = snapshot['alaIzq'] ?? "",
        alaDer = snapshot['alaDer'] ?? "",
        cierre = snapshot['cierre'] ?? "",
        portero = snapshot['portero'] ?? "",
        jornada = snapshot['jornada'] ?? 0;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "admin": admin,
        "points": points,
        "avatar": avatar,
        "position": position,
        'pivot': pivot,
        'alaIzq': alaIzq,
        'alaDer': alaDer,
        'cierre': cierre,
        'portero': portero,
        'jornada': jornada,

      };
}
