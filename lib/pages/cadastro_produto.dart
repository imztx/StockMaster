import 'package:flutter/material.dart';
import '../dao.dart';
import 'package:stock_master/models/produto.dart';

class CadastroProdutoPage extends StatefulWidget {
  const CadastroProdutoPage({super.key});

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _precoController = TextEditingController();

  final db = DatabaseHelper();

  Future<void> _salvarProduto() async {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text.trim();
      final categoria = _categoriaController.text.trim();
      final preco = double.parse(_precoController.text.trim());

      final produto = Produto(nome: nome, categoria: categoria, preco: preco);

      await db.inserirProduto(produto);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto cadastrado com sucesso!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o nome'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe a categoria'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Preço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o preço';
                  }
                  final preco = double.tryParse(value);
                  if (preco == null) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _salvarProduto,
                child: const Text('Salvar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
