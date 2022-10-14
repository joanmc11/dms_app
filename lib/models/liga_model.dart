class LigaModel {

  final bool jornada;
  final String mensaje;

  LigaModel({required this.jornada, required this.mensaje});

   LigaModel.fromMap(Map snapshot)
      : jornada = snapshot['jornada'],
      mensaje = snapshot['mensaje'];

      Map<String, dynamic> toJson() => {
        'jornada':jornada,
        'mensaje':mensaje,
      };
  
}