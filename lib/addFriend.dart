import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un ami'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titre'),
                onSaved: (value) => title = value!,
                validator: (value) => value!.isEmpty ? 'Entrez le pseudo de l\'ami' : null,
              ),
              ElevatedButton(
                onPressed: null,
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
