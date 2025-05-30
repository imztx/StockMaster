import 'package:flutter/material.dart';
import 'package:lista_de_compras/models/usuario.dart';
import 'package:lista_de_compras/pages/cadastro_page.dart';
import '../dao.dart';
import '../pages/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  void _buildLogin() async {
    final email = emailController.text.trim();
    final senha = passwordController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    final Usuario? usuario = await DatabaseHelper().autenticarUsuario(email, senha);

    if (usuario != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bem-vindo, ${usuario.nome}!')));

    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder:
       (context) => const DashboardPage()),
    );
    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou senha incorretos')),
      );
    }
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
          "Área de Login",
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 50),
        _buildForms("Email: "),
        _buildInput(emailController),
        const SizedBox(height: 30),
        _buildForms("Senha: "),
        _buildInput(passwordController, isPassword: true),
        const SizedBox(height: 30),
        _buildLoginRegisterButtom(),
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

  Widget _buildLoginRegisterButtom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _buildLogin();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: const Size(120, 30),
          ),
          child: const Text("LOGIN"),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CadastroPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: const Size(120, 30),
          ),
          child: const Text("CADASTRAR"),
        ),
      ],
    );
  }
}
