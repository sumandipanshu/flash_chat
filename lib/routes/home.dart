import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/loadinglist.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/routes/chat_screen.dart';
import 'package:flash_chat/routes/verification.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const String id = 'home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User _user;

  Future<List<Map<String, dynamic>>> getUsersList() async {
    var usersQuerySnapshot = await _firestore.collection('users').get();
    var usersQueryDocumentSnapshot = usersQuerySnapshot.docs;
    var users = usersQueryDocumentSnapshot
        .map((user) => user.data())
        .toList()
        .where((user) => user['uid'] != _user.uid)
        .toList();
    return users;
  }

  void getCurrentUser() {
    _user = _auth.currentUser;
  }

  String getChatId(String uid, String peerUid) {
    if (uid.hashCode <= peerUid.hashCode) {
      return '$uid-$peerUid';
    } else {
      return '$peerUid-$uid';
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('FlashChat'),
        leading: IconButton(
          onPressed: () async {
            await _auth.signOut();
            print('signed out');
            Navigator.pushReplacementNamed(context, Verification.id);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getUsersList(),
        initialData: [],
        builder: (context, usersSnapshot) {
          if (usersSnapshot.connectionState != ConnectionState.done) {
            return LoadingListPage();
          }
          var users = usersSnapshot.data;
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: users[index]['photoURL'] != null
                      ? NetworkImage(users[index]['photoURL'])
                      : AssetImage('assets/images/user.png'),
                  radius: 25,
                ),
                title: Text(
                  users[index]['name'],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ChatScreen.id,
                    arguments: {
                      'chatId': getChatId(_user.uid, users[index]['uid']),
                      'uid': _user.uid,
                      'peerUid': users[index]['uid'],
                      'peerName': users[index]['name'],
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
