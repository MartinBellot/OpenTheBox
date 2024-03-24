import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openthebox/api.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
    Api api = await Api.getInstance();
    String? from = await api.get('/users/${widget.from}').then((value) => value.data['name']);
    String? to = await api.get('/users/${widget.to}').then((value) => value.data['name']);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      socket.emit('receive_gift', {
        'titre': title,
        'description': description,
        'image': images,
        'musique': music,
        'gift_from': from,
        'gift_to': to
      });
      try {
        await api.post('/gifts', data: {
          'name': title,
          'description': description,
          'images': images,
          'music': music,
          'gift_from': widget.from,
          'gift_to': widget.to
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        images = pickedFile.path;
      });

      // Read the file as bytes
      var bytes = await pickedFile.readAsBytes();

      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse("http://0.0.0.0:8090/upload"));

      // Get the file name
      var fileName = pickedFile.name;

      images = fileName;

      // Add the file to the request
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName, contentType: MediaType('image', 'jpeg')));

      // Send the request
      try {
        var response = await request.send();
        print("File upload response: ${response.statusCode}");
      } catch (e) {
        print("File upload error: $e");
      }
    }
  }

  Future<void> _pickMusic() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        music = pickedFile.path;
      });

      var bytes = await pickedFile.readAsBytes();
      var request = http.MultipartRequest('POST', Uri.parse("http://0.0.0.0:8090/upload"));
      var fileName = pickedFile.name;
      music = fileName;
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName, contentType: MediaType('audio', 'mpeg')));
      try {
        var response = await request.send();
        print("File upload response: ${response.statusCode}");
      } catch (e) {
        print("File upload error: $e");
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
              InkWell(
                onTap: _pickImage,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Image'),
                  child: Text(images.isEmpty ? 'No image selected.' : images),
                ),
              ),
              InkWell(
                onTap: _pickMusic,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Musique'),
                  child: Text(music.isEmpty ? 'No music selected.' : music),
                ),
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
