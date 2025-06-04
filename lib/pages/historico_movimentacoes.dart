import 'package:flutter/material.dart';
import 'package:stock_master/models/movimentacao.dart';
import 'package:stock_master/models/produto.dart';
import 'package:stock_master/models/usuario.dart';
import '../dao.dart';

class HistoricoMovimentacoesPage extends StatefulWidget {
  final Produto produto;
  final Usuario
  usuario; // para mostrar o nome, se quiser filtrar ou exibir algo

  const HistoricoMovimentacoesPage({
    super.key,
    required this.produto,
    required this.usuario,
  });

  @override
  State<HistoricoMovimentacoesPage> createState() =>
      _HistoricoMovimentacoesPageState();
}

class _HistoricoMovimentacoesPageState
    extends State<HistoricoMovimentacoesPage> {
  final db = DatabaseHelper();
  List<Movimentacao> movimentacoes = [];
  Map<int, String> usuarios = {}; // Mapeia IDs para nomes

  @override
  void initState() {
    super.initState();
    carregarMovimentacoes();
  }

  Future<void> carregarMovimentacoes() async {
    final lista = await db.listarMovimentacoesPorProduto(widget.produto.id!);

    Map<int, String> usuariosMap = {};
    for (var m in lista) {
      if (m.usuarioId != null && !usuariosMap.containsKey(m.usuarioId)) {
        final usuario = await db.buscarUsuarioPorId(m.usuarioId!);
        usuariosMap[m.usuarioId!] = usuario?.nome ?? 'Desconhecido';
      }
    }

    setState(() {
      movimentacoes = lista;
      usuarios = usuariosMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico - ${widget.produto.nome}')),
      body:
          movimentacoes.isEmpty
              ? const Center(child: Text('Nenhuma movimentação registrada.'))
              : ListView.builder(
                itemCount: movimentacoes.length,
                itemBuilder: (context, index) {
                  final m = movimentacoes[index];
                  final usuarioNome = usuarios[m.usuarioId] ?? 'Desconhecido';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        '${m.tipo.toUpperCase()} - ${m.quantidade}',
                        style: TextStyle(
                          color:
                              m.tipo == 'entrada' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Data: ${m.data.toLocal()}'),
                          Text('Usuário: $usuarioNome'),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
