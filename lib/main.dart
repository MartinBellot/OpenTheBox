import 'package:flutter/material.dart';
import 'package:openthebox/giftPage.dart';
import 'package:openthebox/giftForm.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _navigateToGiftPage,
              child: Text('Aller à la page cadeau (ouverture de boîte)'),
            ),
            ElevatedButton(
              onPressed: _navigateToGiftCreationPage,
              child: Text('Aller à la page cadeau (création de boîte)'),
            ),
          ],
        ),
      ),
    );
  }
}