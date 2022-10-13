class PlayerModel {
  final String id;
  final String name, surename;
  final int points;
  final String image;
  final bool goalkeeper;
  final int jornada;

  PlayerModel({
    required this.id,
    required this.name,
    required this.surename,
    required this.points,
    required this.image,
    required this.goalkeeper,
    required this.jornada
  });

  PlayerModel.fromMap(Map snapshot, this.id)
      : name = snapshot['name'],
        surename = snapshot['surename'] ?? "",
        points = snapshot['points'],
        image = snapshot['image'] ?? "",
        goalkeeper = snapshot['goalkeeper'],
        jornada = snapshot['jornada'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surename": surename,
        "points": points,
        "image": image,
        "goalkeeper": goalkeeper,
        "jornada": jornada,
      };
}
