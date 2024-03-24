import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  late int from;

  @override
  void initState() {
    super.initState();
    getUsername();
    getFriends();
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
              const H(20),
              const Text('Vos amis'),
              if (friends != null)
                ...friends!.map(
                  (friend) => Row(
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
      final response = await Dio().get('http://0.0.0.0:8090/users/$userId/friends');
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
}

class Friends {
  final int id;
  final String name;

  const Friends({required this.id, required this.name});
}
