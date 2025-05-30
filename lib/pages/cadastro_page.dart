import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/usuario.dart';
import '../pages/login_page.dart';
import '../dao.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPage();
}

class _CadastroPage extends State<CadastroPage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool obscureText = true;


  void _salvarUsuario() async {
    final nome = nomeController.text;
    final email = emailController.text;
    final senha = senhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final usuario = Usuario(nome: nome, email: email, senha: senha);
    await DatabaseHelper().inserirUsuario(usuario);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário cadastrado com sucesso')),
    );

    nomeController.clear();
    emailController.clear();
    senhaController.clear();

    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder:
       (context) => const LoginPage()),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ],
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.all_inbox, size: 100, color: Colors.white),
          Text(
            "StockMaster",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(padding: const EdgeInsets.all(50), child: _buildForm()),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cadastro do Usuário",
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        _buildForms("Nome completo: "),
        _buildInput(nomeController),
        const SizedBox(height: 30),
        _buildForms("Email: "),
        _buildInput(emailController),
        const SizedBox(height: 30),
        _buildForms("Senha: "),
        _buildInput(senhaController, isPassword: true),
        const SizedBox(height: 30),
        _buildCadastroButtom(),
      ],
    );
  }

  Widget _buildForms(String text) {
    return Text(text, style: const TextStyle(color: Colors.grey));
  }

  Widget _buildInput(TextEditingController controller, {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isPassword ? null : null,
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.remove_red_eye : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
                : null,
      ),
      obscureText: isPassword ? obscureText : false,
    );
  }

  Widget _buildCadastroButtom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _salvarUsuario();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: const Size(120, 30),
          ),
          child: const Text("Cadastrar"),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: const Size(120, 30),
          ),
          child: const Text("Voltar Login"),
        ),
      ],
    );
  }
}
