import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SendGiftPage extends StatefulWidget {
  @override
  _SendGiftPageState createState() => _SendGiftPageState();
}

class _SendGiftPageState extends State<SendGiftPage> {
  final _formKey = GlobalKey<FormState>();
  late IO.Socket socket;
  String title = '';
  String description = '';
  String images = '';
  String music = '';

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.connect();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void _sendGift() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      socket.emit('receive_gift', {
        'titre': title,
        'description': description,
        'images': images.split(','),
        'musique': music,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envoyer un cadeau'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titre'),
                onSaved: (value) => title = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Images (comma separated)'),
                onSaved: (value) => images = value!,
                validator: (value) => value!.isEmpty ? 'Please enter at least one image' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Music'),
                onSaved: (value) => music = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a music file' : null,
              ),
              ElevatedButton(
                onPressed: _sendGift,
                child: const Text('Send Gift'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}