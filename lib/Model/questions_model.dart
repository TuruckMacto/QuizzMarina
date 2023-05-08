class Questions {
  final String id;
  final String title;
  final Map<String, bool> options;

  Questions({
    required this.id,
    required this.title,
    required this.options,
  });

  @override
  String toString() {
    return 'questions(id: $id, titlle: $title, options: $options)';
  }
}

class Pregunta {
  String id;
  String pregunta;
  List<String> respuestas;
  int respuestaCorrecta;

  Pregunta({
    required this.id,
    required this.pregunta,
    required this.respuestas,
    required this.respuestaCorrecta,
  });

  // Método para mapear los datos de Firestore a un objeto Pregunta
  factory Pregunta.fromMap(Map<String, dynamic> map) {
    return Pregunta(
      id: map['id'] ?? '',
      pregunta: map['pregunta'] ?? '',
      respuestas: List<String>.from(map['respuestas'] ?? []),
      respuestaCorrecta: map['respuestaCorrecta'] ?? 0,
    );
  }

  // Método para convertir un objeto Pregunta a un mapa de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pregunta': pregunta,
      'respuestas': respuestas,
      'respuestaCorrecta': respuestaCorrecta,
    };
  }
}
