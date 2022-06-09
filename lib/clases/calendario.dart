enum FranjaHoraria {
  desayuno,
  snack,
  almuerzo,
  merienda,
  cena,
}

class Calendario {
  DateTime fecha;
  /*
  - Si en franjas no existe una llave, es que es franja está vacía.
  - La llave es un enum (un entero) que es más conveniente.
  */
  Map<FranjaHoraria, String> franjas = {};

  Calendario(this.fecha);

  Calendario.fromFirestore(Map<String, dynamic> data) : fecha = data['fecha'] {
    final franjasFirestore = data['franjas'] as Map<String, dynamic>;
    for (var entry in franjasFirestore.entries) {
      switch (entry.key) {
        case 'desayuno':
          franjas[FranjaHoraria.desayuno] = entry.value;
          break;
        case 'snack':
          franjas[FranjaHoraria.snack] = entry.value;
          break;
        case 'almuerzo':
          franjas[FranjaHoraria.almuerzo] = entry.value;
          break;
        case 'merienda':
          franjas[FranjaHoraria.merienda] = entry.value;
          break;
        case 'cena':
          franjas[FranjaHoraria.cena] = entry.value;
          break;
        default:
          throw "Una llave de las franjas horarias es desconocida ${entry.key}";
      }
    }
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {
      'fecha': fecha,
    };
    final Map<String, String> franjasFirestore = {};
    for (var entry in franjas.entries) {
      franjasFirestore[entry.key.toString()] = entry.value;
    }
    data['franjas'] = franjasFirestore;
    return data;
  }
}
