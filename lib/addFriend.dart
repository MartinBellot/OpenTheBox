import 'package:flutter/material.dart';
import 'package:openthebox/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un ami'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Ami'),
              validator: (value) => value!.isEmpty ? 'Entrez le pseudo de l\'ami' : null,
            ),
            ElevatedButton(
              onPressed: () => addFriend(),
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  void addFriend() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final Api api = await Api.getInstance();
    int? friendId;
    print('friend: ${_controller.text}');
    try {
      final res = await api.get('/users/name/${_controller.text}');
      print('res: $res');
      friendId = res.data['id'];
    } catch (e) {
      print('Error: $e');
      Navigator.pop(context);
      return;
    }
    try {
      print('userId: $userId, friendId: $friendId');
      await api.post('/users/$userId/add/friends', data: {'friendId': friendId});
    } catch (e) {
      print('Error: $e');
      Navigator.pop(context);
      return;
    }
    Navigator.pop(context);
  }
}
