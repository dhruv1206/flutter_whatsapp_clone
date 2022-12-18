import 'package:flutter/material.dart';
import './colors.dart';
import './responsive/responsive_layout.dart';
import './screens/mobile_screen_layout.dart';
import './screens/web_screen_layout.dart';

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
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor, useMaterial3: true),
      home: const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout()),
    );
  }
}
