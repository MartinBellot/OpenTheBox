import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openthebox/addFriend.dart';
import 'package:openthebox/api.dart';
import 'package:openthebox/customSizedBox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gifts/sendGiftPage.dart';

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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
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
                    }),
                    icon: const Icon(
                      Icons.refresh,
                    ),
                  ),
                ],
              ),
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
}

class Friends {
  final int id;
  final String name;

  const Friends({required this.id, required this.name});
}
