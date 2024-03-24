import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SendGiftPage extends StatefulWidget {
  final int from;
  final int to;

  const SendGiftPage({Key? key, required this.from, required this.to}) : super(key: key);

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

  void _sendGift() async {
    String? from = await Dio().get('http://0.0.0.0:8090/users/${widget.from}').then((value) => value.data['name']);
    String? to = await Dio().get('http://0.0.0.0:8090/users/${widget.to}').then((value) => value.data['name']);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      socket.emit('receive_gift', {
        'titre': title,
        'description': description,
        'images': images.split(','),
        'musique': music,
      });
      try {
        await Dio().post('http://0.0.0.0:8090/gifts', data: {
          'name': title,
          'description': description,
          'images': images,
          'music': music,
          'from': widget.from,
          'to': widget.to
        });
        Navigator.pop(context);
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
