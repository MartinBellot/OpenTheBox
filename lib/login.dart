import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openthebox/customSizedBox.dart';
import 'package:openthebox/home.dart';

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
                const Spacer(),
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 250,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Register())),
                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                        child: const Text("S'inscrire", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const H(8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignIn())),
                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                        child: Text('Se connecter', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      ),
                    ),
                  ],
                ),
                const H(20),
              ],
            ),
          ),
        ),
      );
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text('Inscription', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const H(20),
                const Text('Email'),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Entrez votre email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const H(20),
                const Text('Mot de passe'),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(hintText: 'Entrez votre mot de passe'),
                  obscureText: true,
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await Dio().post('http://0.0.0.0:8090/users',
                                data: {'name': emailController.text, 'password': passwordController.text});
                          } catch (e) {
                            if (e is DioError) {
                              print('Message: ${e.message}');
                              print('Response data: ${e.response?.data}');
                              print('Response headers: ${e.response?.headers}');
                            } else {
                              print(e);
                            }
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                        child: const Text("S'inscrire", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const H(20),
              ],
            ),
          ),
        ),
      );
}

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text('Connexion', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const H(20),
                const Text('Email'),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Entrez votre email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const H(20),
                const Text('Mot de passe'),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(hintText: 'Entrez votre mot de passe'),
                  obscureText: true,
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          print('do call api');
                          try {
                            final response = await Dio().post('http://0.0.0.0:8090/signin',
                                data: {'name': emailController.text, 'password': passwordController.text});
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                          } catch (e) {
                            if (e is DioError) {
                              print('Message: ${e.message}');
                              print('Response data: ${e.response?.data}');
                              print('Response headers: ${e.response?.headers}');
                              Navigator.pop(context);
                            } else {
                              print(e);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                        child: const Text('Se connecter', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const H(20),
              ],
            ),
          ),
        ),
      );
}
