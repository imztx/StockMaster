import 'package:flutter/material.dart';
import '../dao.dart';
import 'package:lista_de_compras/models/movimentacao.dart';
import 'package:lista_de_compras/models/produto.dart';

class MovimentacaoPage extends StatefulWidget {
  final Produto produto;

  const MovimentacaoPage({super.key, required this.produto});

  @override
  State<MovimentacaoPage> createState() => _MovimentacaoPageState();
}

class _MovimentacaoPageState extends State<MovimentacaoPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantidadeController = TextEditingController();
  String tipo = 'entrada';

  final db = DatabaseHelper();

  Future<void> _salvarMovimentacao() async {
    if (_formKey.currentState!.validate()) {
      final quantidade = int.parse(_quantidadeController.text.trim());

      final movimentacao = Movimentacao(
        produtoId: widget.produto.id!,
        tipo: tipo,
        quantidade: quantidade,
        data: DateTime.now(),
      );

      await db.inserirMovimentacao(movimentacao);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movimentação registrada com sucesso!')),
      );

      Navigator.pop(context); // Volta para o dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movimentação - ${widget.produto.nome}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: tipo,
                items: const [
                  DropdownMenuItem(value: 'entrada', child: Text('Entrada')),
                  DropdownMenuItem(value: 'saida', child: Text('Saída')),
                ],
                onChanged: (value) {
                  setState(() {
                    tipo = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo de Movimentação',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a quantidade';
                  }
                  final q = int.tryParse(value);
                  if (q == null || q <= 0) {
                    return 'Quantidade inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _salvarMovimentacao,
                child: const Text('Registrar Movimentação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
