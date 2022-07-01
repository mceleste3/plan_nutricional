String formateaFecha(DateTime d) {
  return "${d.year.toStringAsFixed(4)}-${d.month.toStringAsFixed(2)}-${d.day.toStringAsFixed(2)}";
}

bool fechasIguales(DateTime a, DateTime b) {
  return formateaFecha(a) == formateaFecha(b);
}
