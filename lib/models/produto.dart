class Produto {
  final int? id;
  final String nome;
  final String categoria;
  final double preco;

  Produto({
    this.id,
    required this.nome,
    required this.categoria,
    required this.preco,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'categoria': categoria, 'preco': preco};
  }

  static Produto fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      categoria: map['categoria'],
      preco: map['preco'],
    );
  }
}
