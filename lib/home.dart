import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openthebox/addFriend.dart';
import 'package:openthebox/api.dart';
import 'package:openthebox/customSizedBox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gifts/sendGiftPage.dart';
import 'gifts/giftPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? username;
  List<Friends>? friends;
  List<Friends>? suggestions;
  late int from;

  @override
  void initState() {
    super.initState();
    getUsername();
    getFriends();
    getSuggestions();
    getFrom();
  }

  void navigateToReceiveGift() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GiftPage()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text('Bonjour $username'),
              ElevatedButton(onPressed: navigateToReceiveGift, child: const Text('Recevoir un cadeau')),
              Row(
                children: [
                  Text('Bonjour $username'),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddFriendPage()),
                      );
                    },
                    icon: const Icon(Icons.person_add),
                  ),
                ],
              ),
              const H(10),
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () => setState(() {
                      friends = null;
                      getFriends();
                      suggestions = null;
                      getSuggestions();
                    }),
                    icon: const Icon(
                      Icons.refresh,
                    ),
                  ),
                ],
              ),
              const H(20),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text('Vos amis'),
              ),
              const Text('Cliquez sur l\'icône pour envoyer un cadeau 🎁'),
              if (friends != null)
                ...friends!.map(
                  (friend) => Card(
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const W(10),
                        Text(friend.name),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SendGiftPage(from: from, to: friend.id)),
                            );
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
              const H(10),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text("Suggestion d'ami"),
              ),
              if (suggestions != null)
                ...suggestions!.map(
                  (friend) => Card(
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const W(10),
                        Text(friend.name),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddFriendPage(friend: friend.name)),
                            );
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  void getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  void getFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      final Api api = await Api.getInstance();
      final response = await api.get('/users/$userId/friends');
      setState(() {
        friends = (response.data as List).map((data) => Friends(id: data['id'], name: data['name'])).toList();
      });
    }
  }

  void getFrom() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      setState(() {
        from = userId;
      });
    }
  }

  void getSuggestions() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      final Api api = await Api.getInstance();
      final response = await api.get('/users/$userId/suggestions');
      setState(() {
        suggestions = (response.data as List).map((data) => Friends(id: data['id'], name: data['name'])).toList();
      });
    }
  }
}

class Friends {
  final int id;
  final String name;

  const Friends({required this.id, required this.name});
}
