class PlayerModel {
  final String id;
  final String name, surename;
  final int points;
  final String image;
  final bool goalkeeper;
  final int jornada;
  final bool punctuated;
  final List<dynamic> jornadaList;

  PlayerModel({
    required this.id,
    required this.name,
    required this.surename,
    required this.points,
    required this.image,
    required this.goalkeeper,
    required this.jornada,
    required this.punctuated,
    required this.jornadaList,
  });

  PlayerModel.fromMap(Map snapshot, this.id)
      : name = snapshot['name'],
        surename = snapshot['surename'] ?? "",
        points = snapshot['points'],
        image = snapshot['image'] ?? "",
        goalkeeper = snapshot['goalkeeper'],
        jornada = snapshot['jornada'] ?? 0,
        punctuated = snapshot['punctuated'],
        jornadaList = snapshot['jornadaList'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surename": surename,
        "points": points,
        "image": image,
        "goalkeeper": goalkeeper,
        "jornada": jornada,
        "punctuated": punctuated,
        'jornadaList': jornadaList,
      };
}
