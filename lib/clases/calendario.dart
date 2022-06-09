class Calendario {
  DateTime fecha;
  Map<String, String> franja = {
    'desayuno': '',
    'snack': '',
    'almuerzo': '',
    'merianda': '',
    'cena': ''
  };
  Calendario(this.fecha);

  Calendario.fromFirestore(Map<String, dynamic> data)
      : fecha = data['fecha'],
        franja = data['franja'];

  Map<String, dynamic> toFirestore() => {
        'fecha': fecha,
        'franaja': franja,
      };
}
