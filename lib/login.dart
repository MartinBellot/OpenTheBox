import 'package:flutter/material.dart';
import 'package:openthebox/customSizedBox.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                /*SizedBox(
                  width: 180,
                  height: 60,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),*/
                const Spacer(),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text("S'inscrire", style: TextStyle(color: Colors.white)),
                ),
                const H(8),
                ElevatedButton(
                  onPressed: null,
                  child: Text('Se connecter', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                ),
                const H(20),
              ],
            ),
          ),
        ),
      );
}
