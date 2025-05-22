import 'package:flutter/material.dart';
import 'package:lista_de_compras/pages/movimentacao_page.dart';
import '../dao.dart';
import 'package:lista_de_compras/models/produto.dart';
import 'cadastro_produto.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

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
      body:
          produtos.isEmpty
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
                        ],
                      ),
                      trailing: Text(
                        'Estoque: $saldo',
                        style: TextStyle(
                          color: saldo > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MovimentacaoPage(produto: produto),
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
          carregarProdutos(); // Atualiza o dashboard ao voltar
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
