class LigaModel {

  final bool jornada;

  LigaModel({required this.jornada});

   LigaModel.fromMap(Map snapshot)
      : jornada = snapshot['jornada'];

      Map<String, dynamic> toJson() => {
        'jornada':jornada,
      };
  
}