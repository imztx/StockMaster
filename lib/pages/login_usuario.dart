import 'package:flutter/material.dart';
import '../widgets/login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text("StockMaster"),
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return Center(
    child: ListView(
      padding: const EdgeInsets.all(15),
      children: const [LoginButton()]
      ),
    );
  }
}