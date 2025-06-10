import 'package:flutter/material.dart';
import 'package:stock_master/models/usuario.dart';
import 'package:stock_master/pages/movimentacao_page.dart';
import '../dao.dart';
import 'package:stock_master/models/produto.dart';
import 'cadastro_produto.dart';
import 'historico_movimentacoes.dart';

class DashboardPage extends StatefulWidget {
  final Usuario usuario;
  const DashboardPage({super.key, required this.usuario});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final db = DatabaseHelper();
  List<Produto> produtos = [];
  Map<int, int> estoques = {};

  @override
  void initState() {
    super.initState();
    carregarProdutos();
  }

  Future<void> carregarProdutos() async {
    final lista = await db.listarProdutos();

    Map<int, int> saldos = {};
    for (var p in lista) {
      final saldo = await db.calcularEstoque(p.id!);
      saldos[p.id!] = saldo;
    }

    setState(() {
      produtos = lista;
      estoques = saldos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StockMaster - Dashboard')),
      body: produtos.isEmpty
          ? const Center(child: Text('Nenhum produto cadastrado'))
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                final saldo = estoques[produto.id!] ?? 0;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(produto.nome),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Categoria: ${produto.categoria}'),
                        Text(
                          'Preço: R\$ ${produto.preco.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Estoque: $saldo',
                          style: TextStyle(
                            color: saldo > 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'movimentacao') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovimentacaoPage(
                                produto: produto,
                                usuario: widget.usuario,
                              ),
                            ),
                          );
                          carregarProdutos();
                        } else if (value == 'historico') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HistoricoMovimentacoesPage(
                                produto: produto,
                                usuario: widget.usuario,
                              ),
                            ),
                          );
                        } else if (value == 'excluir') {
                          final confirmado = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: Text(
                                  'Deseja realmente excluir o produto "${produto.nome}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Excluir'),
                                ),
                              ],
                            ),
                          );

                          if (confirmado == true) {
                            await db.deletarProduto(produto.id!);
                            carregarProdutos();
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'movimentacao',
                          child: Text('Nova Movimentação'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'historico',
                          child: Text('Ver Histórico'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'excluir',
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovimentacaoPage(
                            produto: produto,
                            usuario: widget.usuario,
                          ),
                        ),
                      );
                      carregarProdutos();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroProdutoPage(),
            ),
          );
          carregarProdutos();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
