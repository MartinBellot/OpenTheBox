import 'package:flutter/material.dart';
import 'package:openthebox/login.dart';
import 'package:openthebox/theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:openthebox/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  @override
  Widget build(BuildContext context) => const Login();
}
