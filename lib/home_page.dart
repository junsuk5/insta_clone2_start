import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'feed_widget.dart';

class HomePage extends StatelessWidget {
  final FirebaseUser user;

  HomePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Instagram Clone',
            style: GoogleFonts.pacifico(),
          ),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('post').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _buildNoPostBody();
            }
            return _buildHasPostBody(snapshot.data.documents);
          }
      ),
    );
  }

  // 아무런 게시물이 없을 때의 바디
  Widget _buildNoPostBody() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Instagram에 오신 것을 환영합니다',
              style: TextStyle(fontSize: 24.0),
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Text('사진과 동영상을 보려면 팔로우하세요.'),
            Padding(padding: EdgeInsets.all(16.0)),
            SizedBox(
              width: 260.0,
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      Text(
                        user.email,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(user.displayName),
                      Padding(padding: EdgeInsets.all(8.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 70.0,
                            height: 70.0,
                            child: Image.network(
                                'https://cdn.pixabay.com/photo/2017/09/21/19/12/france-2773030_1280.jpg',
                                fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: EdgeInsets.all(1.0),
                          ),
                          SizedBox(
                            width: 70.0,
                            height: 70.0,
                            child: Image.network(
                                'https://cdn.pixabay.com/photo/2017/06/21/05/42/fog-2426131_1280.jpg',
                                fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: EdgeInsets.all(1.0),
                          ),
                          SizedBox(
                            width: 70.0,
                            height: 70.0,
                            child: Image.network(
                                'https://cdn.pixabay.com/photo/2019/02/04/20/07/flowers-3975556_1280.jpg',
                                fit: BoxFit.cover),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(4.0)),
                      Text('Facebook 친구'),
                      Padding(padding: EdgeInsets.all(4.0)),
                      RaisedButton(
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          child: Text('팔로우'),
                          onPressed: () => print('팔로우 클릭')),
                      Padding(padding: EdgeInsets.all(4.0))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 게시물이 있을 경우에 표시한 body
  Widget _buildHasPostBody(List<DocumentSnapshot> documents) {
    // 내 게시물 5개
    final myPosts = documents
        .where((doc) => doc['email'] == user.email)
        .take(5)
        .toList();

    // 다른 사람 게시물 10개
    final otherPosts = documents
        .where((doc) => doc['email'] != user.email)
        .take(10)
        .toList();

    // 합치기
    myPosts.addAll(otherPosts);

    return ListView(
      children: myPosts.map((doc) => FeedWidget(doc, user)).toList(),
    );
  }

}