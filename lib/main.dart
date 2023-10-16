import 'package:flutter/material.dart';
import 'package:nota_fiscal/modules/cliente/pages/cliente_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas Fiscais',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue.shade900),
        useMaterial3: true,
      ),
      home: const ClienteListPage(),
    );
  }
}
