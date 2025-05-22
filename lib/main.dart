import 'package:flutter/material.dart';
import 'pages/dashboard.dart';

void main() {
  runApp(const StockMasterApp());
}

class StockMasterApp extends StatelessWidget {
  const StockMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StockMaster',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DashboardPage(),
    );
  }
}
