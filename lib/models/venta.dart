class DetalleVentaInput {
  final int productoId;
  final int cantidad;

  const DetalleVentaInput({required this.productoId, required this.cantidad});
}

class VentaCreada {
  final int id;
  final double total;

  const VentaCreada({required this.id, required this.total});

  Map<String, dynamic> toMap() => {'id': id, 'total': total};
}
