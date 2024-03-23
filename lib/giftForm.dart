import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class GiftForm extends StatefulWidget {
  const GiftForm({Key? key}) : super(key: key);

  @override
  _GiftFormState createState() => _GiftFormState();
}

class _GiftFormState extends State<GiftForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _images = [];
  String? _selectedMusic;

  void _selectMusic(String? value) {
    setState(() {
      _selectedMusic = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créé ton cadeau'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {print("test");},
              child: const Text('Ajouter des images'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedMusic,
              onChanged: _selectMusic,
              items: const [
                DropdownMenuItem(
                  value: 'music1.mp3',
                  child: Text('Musique 1'),
                ),
                DropdownMenuItem(
                  value: 'music2.mp3',
                  child: Text('Musique 2'),
                ),
              ],
              decoration: const InputDecoration(labelText: 'Musique pour l\'ouverture'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Create a Gift object
                var gift = Gift(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  images: _images,
                  music: _selectedMusic,
                );

                // Convert the Gift to a JSON string
                var json = gift.toJson();

                // TODO: Save the JSON string to a file
                print(json);
              },
              child: const Text('Créer le cadeau'),
            ),
          ],
        ),
      ),
    );
  }
}




// Modèle de données pour le cadeau
class Gift {
  final String title;
  final String description;
  final List<String> images;
  final String? music;

  Gift({
    required this.title,
    required this.description,
    required this.images,
    this.music,
  });

  // Convert a Gift to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'images': images,
      'music': music,
    };
  }

  // Convert a Gift to a JSON string
  String toJson() => jsonEncode(toMap());
}
