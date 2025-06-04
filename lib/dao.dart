import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'models/produto.dart';
import 'models/movimentacao.dart';
import 'models/usuario.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'stockmaster.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE produtos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        categoria TEXT NOT NULL,
        preco REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE movimentacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produto_id INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        quantidade INTEGER NOT NULL,
        data TEXT NOT NULL,
        usuario_id INTEGER,
        FOREIGN KEY (produto_id) REFERENCES produtos(id)
      )
    ''');
  }

  // ========== USUÁRIOS ==========
  Future<int> inserirUsuario(Usuario usuario) async {
    final db = await database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> autenticarUsuario(String email, String senha) async {
    final db = await database;
    final result = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<Usuario?> buscarUsuarioPorId(int id) async {
    final db = await database;
    final result = await db.query('usuarios', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    } else {
      return null;
    }
  }

  // ========== PRODUTOS ==========
  Future<int> inserirProduto(Produto produto) async {
    final db = await database;
    return await db.insert('produtos', produto.toMap());
  }

  Future<List<Produto>> listarProdutos() async {
    final db = await database;
    final result = await db.query('produtos');
    return result.map((map) => Produto.fromMap(map)).toList();
  }

  Future<int> atualizarProduto(Produto produto) async {
    final db = await database;
    return await db.update(
      'produtos',
      produto.toMap(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  Future<int> deletarProduto(int id) async {
    final db = await database;
    return await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }

  // ========== MOVIMENTAÇÕES ==========
  Future<int> inserirMovimentacao(Movimentacao m) async {
    final db = await database;
    return await db.insert('movimentacoes', m.toMap());
  }

  Future<List<Movimentacao>> listarMovimentacoesPorProduto(
    int produtoId,
  ) async {
    final db = await database;
    final result = await db.query(
      'movimentacoes',
      where: 'produto_id = ?',
      whereArgs: [produtoId],
      orderBy: 'data DESC',
    );
    return result.map((map) => Movimentacao.fromMap(map)).toList();
  }

  Future<int> calcularEstoque(int produtoId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT SUM(CASE WHEN tipo = 'entrada' THEN quantidade ELSE -quantidade END) as saldo
      FROM movimentacoes
      WHERE produto_id = ?
    ''',
      [produtoId],
    );

    return result.first['saldo'] == null ? 0 : result.first['saldo'] as int;
  }
}
