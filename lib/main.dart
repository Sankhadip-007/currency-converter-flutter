import 'package:flutter/material.dart';
import 'package:xchange/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xchange',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: CurrencyConverter(),
    );
  }
}


