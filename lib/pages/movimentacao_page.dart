import 'package:flutter/material.dart';
import '../dao.dart';
import 'package:stock_master/models/movimentacao.dart';
import 'package:stock_master/models/produto.dart';
import 'package:stock_master/models/usuario.dart';

class MovimentacaoPage extends StatefulWidget {
  final Produto produto;
  final Usuario usuario;

  const MovimentacaoPage({
    super.key,
    required this.produto,
    required this.usuario,
  });

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

      if (tipo == 'saida') {
        final estoqueAtual = await db.calcularEstoque(widget.produto.id!);

        if (quantidade > estoqueAtual) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Estoque insuficiente para retirar. Disponível: $estoqueAtual',
              ),
            ),
          );
          return;
        }
      }

      final movimentacao = Movimentacao(
        produtoId: widget.produto.id!,
        tipo: tipo,
        quantidade: quantidade,
        data: DateTime.now(),
        usuarioId: widget.usuario.id,
      );

      await db.inserirMovimentacao(movimentacao);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movimentação registrada com sucesso!')),
      );

      Navigator.pop(context);
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
              const SizedBox(height: 32),
              Text(
                'Tipo de movimentação',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
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
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Quantidade',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Informe a quantidade',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
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
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _salvarMovimentacao,
                  child: const Text('Registrar Movimentação'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
