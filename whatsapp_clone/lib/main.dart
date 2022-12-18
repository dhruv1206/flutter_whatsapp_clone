import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp Clone',
      theme: ThemeData.dark().copyWith(backgroundColor: backgroundColor),
      home: const Text("Hello World"),
    );
  }
}
