class Movimentacao {
  final int? id;
  final int produtoId;
  final String tipo;
  final int quantidade;
  final DateTime data;
  final int? usuarioId;

  Movimentacao({
    this.id,
    required this.produtoId,
    required this.tipo,
    required this.quantidade,
    required this.data,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produto_id': produtoId,
      'tipo': tipo,
      'quantidade': quantidade,
      'data': data.toIso8601String(),
      'usuario_id': usuarioId,
    };
  }

  static Movimentacao fromMap(Map<String, dynamic> map) {
    return Movimentacao(
      id: map['id'],
      produtoId: map['produto_id'],
      tipo: map['tipo'],
      quantidade: map['quantidade'],
      data: DateTime.parse(map['data']),
      usuarioId: map['usuario_id'],
    );
  }
}
