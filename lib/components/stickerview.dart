import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/global.dart';
import 'package:flutter/material.dart';

class StickerView extends StatefulWidget {
  StickerView({this.firestore, this.user, this.scrollController});
  final FirebaseFirestore firestore;
  final User user;
  final ScrollController scrollController;
  @override
  _StickerViewState createState() => _StickerViewState();
}

class _StickerViewState extends State<StickerView>
    with TickerProviderStateMixin {
  TabController _stickerTabController;

  @override
  void initState() {
    super.initState();

    _stickerTabController = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _stickerTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = 250;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TabBar(
          controller: _stickerTabController,
          indicatorColor: Colors.teal,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              child: Image.asset('assets/stickers/ben/ben (1).png'),
            ),
            Tab(
              child: Image.asset(
                  'assets/stickers/cute-couple/cute-couple (3).png'),
            ),
            Tab(
              child: Image.asset(
                  'assets/stickers/little-girl/little-girl (2).png'),
            ),
            Tab(
              child:
                  Image.asset('assets/stickers/milk&mocha/milk&mocha (3).png'),
            ),
          ],
        ),
        Container(
          height: screenHeight * 0.70,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: TabBarView(
            controller: _stickerTabController,
            children: <Widget>[
              GridView.count(
                crossAxisCount: 3,
                children: List.generate(40, (index) {
                  return GestureDetector(
                    onTap: () {
                      widget.firestore.collection('messages').add({
                        'type': 'sticker',
                        'uid': widget.user.uid,
                        'data': ben[index],
                        'timestamp': Timestamp.now().millisecondsSinceEpoch,
                      });
                      Future.delayed(Duration(milliseconds: 100), () {
                        widget.scrollController.animateTo(
                            widget.scrollController.position.minScrollExtent,
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 500));
                      });
                    },
                    child: Image.asset(ben[index]),
                  );
                }),
              ),
              GridView.count(
                crossAxisCount: 3,
                children: List.generate(40, (index) {
                  return GestureDetector(
                    onTap: () {
                      widget.firestore.collection('messages').add({
                        'type': 'sticker',
                        'uid': widget.user.uid,
                        'data': cute_couple[index],
                        'timestamp': Timestamp.now().millisecondsSinceEpoch,
                      });
                      Future.delayed(Duration(milliseconds: 100), () {
                        widget.scrollController.animateTo(
                            widget.scrollController.position.minScrollExtent,
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 500));
                      });
                    },
                    child: Image.asset(cute_couple[index]),
                  );
                }),
              ),
              GridView.count(
                crossAxisCount: 3,
                children: List.generate(40, (index) {
                  return GestureDetector(
                    onTap: () {
                      widget.firestore.collection('messages').add({
                        'type': 'sticker',
                        'uid': widget.user.uid,
                        'data': little_girl[index],
                        'timestamp': Timestamp.now().millisecondsSinceEpoch,
                      });
                      Future.delayed(Duration(milliseconds: 100), () {
                        widget.scrollController.animateTo(
                            widget.scrollController.position.minScrollExtent,
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 500));
                      });
                    },
                    child: Image.asset(little_girl[index]),
                  );
                }),
              ),
              GridView.count(
                crossAxisCount: 3,
                children: List.generate(40, (index) {
                  return GestureDetector(
                    onTap: () {
                      widget.firestore.collection('messages').add({
                        'type': 'sticker',
                        'uid': widget.user.uid,
                        'data': milk_mocha[index],
                        'timestamp': Timestamp.now().millisecondsSinceEpoch,
                      });
                      Future.delayed(Duration(milliseconds: 100), () {
                        widget.scrollController.animateTo(
                            widget.scrollController.position.minScrollExtent,
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 500));
                      });
                    },
                    child: Image.asset(milk_mocha[index]),
                  );
                }),
              ),
            ],
          ),
        )
      ],
    );
  }
}
