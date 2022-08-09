import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailPostPage extends StatelessWidget {
  final DocumentSnapshot document;
  final FirebaseUser user;

  DetailPostPage(this.document, this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('둘러보기'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(document['userPhotoUrl']),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            document['email'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          StreamBuilder<DocumentSnapshot>(
                              stream: _followingStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text('로딩중');
                                }

                                var data = snapshot.data.data;
                                if (data == null ||
                                    data[document['email']] == null ||
                                    data[document['email']] == false
                                ) {
                                  return GestureDetector(
                                    onTap: _follow,
                                    child: Text(
                                      "팔로우",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }

                                return GestureDetector(
                                  onTap: _unfollow,
                                  child: Text(
                                    "언팔로우",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                          ),
                        ],
                      ),
                      Text(document['displayName']),
                    ],
                  ),
                )
              ],
            ),
          ),
          Hero(
            tag: document.documentID,
            child: Image.network(
              document['photoUrl'],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(document['contents']),
          ),
        ],
      ),
    );
  }

  // 팔로우
  void _follow() {
    Firestore.instance
        .collection('following')
        .document(user.email)
        .setData({document['email']: true});

    Firestore.instance
        .collection('follower')
        .document(document['email'])
        .setData({user.email: true});
  }

  // 언팔로우
  void _unfollow() {
    Firestore.instance
        .collection('following')
        .document(user.email)
        .setData({document['email']: false});

    Firestore.instance
        .collection('follower')
        .document(document['email'])
        .setData({user.email: false});
  }

  // 팔로잉 상태를 얻는 스트림
  Stream<DocumentSnapshot> _followingStream() {
    return Firestore.instance
        .collection('following')
        .document(user.email)
        .snapshots();
  }

}