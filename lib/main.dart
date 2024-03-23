import 'package:flutter/material.dart';
import 'package:openthebox/giftPage.dart';
import 'package:openthebox/giftForm.dart';
import 'package:openthebox/login.dart';
import 'package:openthebox/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenTheBox',
      theme: ThemeOpenTheBox.lightTheme,
      home: const MyHomePage(title: 'OpenTheBox'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _navigateToGiftPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GiftPage()),
    );
  }

  void _navigateToGiftCreationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GiftForm()),
    );
  }

  @override
  Widget build(BuildContext context) => Login();
}
