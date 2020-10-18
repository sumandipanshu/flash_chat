import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/global.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const String id = 'home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _firestore = FirebaseFirestore.instance;
  var users;

  void getUsersList() async {
    users = await _firestore.collection('users').get();
    users = users.docs;
    users = users.map((user) => user.data()).toList();
    print(users);
  }

  @override
  void initState() {
    super.initState();
    getUsersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('FlashChat'),
        actions: [Icon(Icons.more_vert)],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: users.length,
              backgroundImage: NetworkImage(users[index]['photoURL']),
            ),
            title: Text(
              users[index]['name'],
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
