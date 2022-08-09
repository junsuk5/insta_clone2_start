import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountPage extends StatelessWidget {
  final FirebaseUser user;

  AccountPage(this.user);

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildProfile(),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: GestureDetector(
                    onTap: () => print('이미지 클릭'),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                  ),
                ),
                Container(
                  width: 80.0,
                  height: 80.0,
                  alignment: Alignment.bottomRight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 28.0,
                        height: 28.0,
                        child: FloatingActionButton(
                          onPressed: null,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: FloatingActionButton(
                          backgroundColor: Colors.blue,
                          onPressed: null,
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Text(
              user.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: _postStream(),
              builder: (context, snapshot) {
                var post = 0;
                if (snapshot.hasData) {
                  post = snapshot.data.documents.length;
                }

                return Text(
                  '$post\n게시물',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                );
              }
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: StreamBuilder<DocumentSnapshot>(
              stream: _followerStream(),
              builder: (context, snapshot) {
                var follower = 0;
                if (snapshot.hasData) {
                  var filteredMap;
                  if (snapshot.data.data == null) {
                    filteredMap = [];
                  } else {
                    filteredMap = snapshot.data.data
                      ..removeWhere((key, value) => value == false);
                  }
                  follower = filteredMap.length;
                }

                return Text(
                  '$follower\n팔로워',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                );
              }
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: StreamBuilder<DocumentSnapshot>(
              stream: _followingStream(),
              builder: (context, snapshot) {
                var following = 0;
                if (snapshot.hasData) {
                  var filteredMap;
                  if (snapshot.data.data == null) {
                    filteredMap = [];
                  } else {
                    filteredMap = snapshot.data.data
                      ..removeWhere((key, value) => value == false);
                  }
                  following = filteredMap.length;
                }

                return Text(
                  '$following\n팔로잉',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                );
              }
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          color: Colors.black,
          onPressed: () {
            // 로그아웃
            FirebaseAuth.instance.signOut();
            _googleSignIn.signOut();
          },
        )
      ],
      backgroundColor: Colors.white,
      title: Text(
        'Instagram Clone',
        style: GoogleFonts.pacifico(),
      ),
    );
  }

  // 내 게시물 가져오기
  Stream<QuerySnapshot> _postStream() {
    return Firestore.instance
        .collection('post')
        .where('email', isEqualTo: user.email)
        .snapshots();
  }

  // 팔로잉 가져오기
  Stream<DocumentSnapshot> _followingStream() {
    return Firestore.instance
        .collection('following')
        .document(user.email)
        .snapshots();
  }

  // 팔로워 가져오기
  Stream<DocumentSnapshot> _followerStream() {
    return Firestore.instance
        .collection('follower')
        .document(user.email)
        .snapshots();
  }
}