import 'package:flutter/material.dart';
import 'pages/portfolio_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Karam Portfolio',
      theme: ThemeData.dark(useMaterial3: true),
      home: const PortfolioHomePage(),
    );
  }
}
