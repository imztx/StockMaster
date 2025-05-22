class Movimentacao {
  final int? id;
  final int produtoId;
  final String tipo; // 'entrada' ou 'saida'
  final int quantidade;
  final DateTime data;

  Movimentacao({
    this.id,
    required this.produtoId,
    required this.tipo,
    required this.quantidade,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produto_id': produtoId,
      'tipo': tipo,
      'quantidade': quantidade,
      'data': data.toIso8601String(),
    };
  }

  static Movimentacao fromMap(Map<String, dynamic> map) {
    return Movimentacao(
      id: map['id'],
      produtoId: map['produto_id'],
      tipo: map['tipo'],
      quantidade: map['quantidade'],
      data: DateTime.parse(map['data']),
    );
  }
}
