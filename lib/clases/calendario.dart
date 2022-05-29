class Calendario {
  DateTime fecha;
  Map<String, String> franja = {
    'desayuno': 'idComida',
    'snack': 'idComida',
    'almuerzo': 'idComida',
    'merianda': 'idComida',
    'cena': 'idComida'
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
