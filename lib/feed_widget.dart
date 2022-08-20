import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'comment_page.dart';

class FeedWidget extends StatefulWidget {
  final DocumentSnapshot document;

  final User user;

  FeedWidget(this.document, this.user);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final _commentController = TextEditingController();

  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.document.data() as Map<String, dynamic>;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var commentCount = data['commentCount'] ?? 0;
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data['userPhotoUrl']),
          ),
          title: Text(
            data['email'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Icon(Icons.more_vert),
        ),
        Image.network(
          data['photoUrl'],
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              data['likedUsers']?.contains(widget.user.email) ??
                  false
                  ? GestureDetector(
                onTap: _unlike,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              )
                  : GestureDetector(
                onTap: _like,
                child: Icon(Icons.favorite_border),
              ),
              SizedBox(
                width: 8.0,
              ),
              Icon(Icons.comment),
              SizedBox(
                width: 8.0,
              ),
              Icon(Icons.send),
            ],
          ),
          trailing: Icon(Icons.bookmark_border),
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 16.0,
            ),
            Text(
              '좋아요 ${data['likedUsers']?.length ?? 0}개',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 16.0,
            ),
            Text(
              data['email'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(data['contents']),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        if (commentCount > 0)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentPage(widget.document),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '댓글 $commentCount개 모두 보기',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  Text(data['lastComment'] ?? ''),
                ],
              ),
            ),
          ),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: TextField(
                  controller: _commentController,
                  onSubmitted: (text) {
                    _writeComment(text);
                    _commentController.text = '';
                  },
                  decoration: InputDecoration(
                    hintText: '댓글 달기',
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  // 좋아요
  void _like() {
    // 기존 좋아요 리스트를 복사
    final List likedUsers =
    List<String?>.from(data['likedUsers'] ?? []);

    // 나를 추가
    likedUsers.add(widget.user.email);

    // 업데이트할 항목을 문서로 준비
    final updateData = {
      'likedUsers': likedUsers,
    };

    FirebaseFirestore.instance
        .collection('post')
        .doc(widget.document.id)
        .update(updateData);
  }

  // 좋아요 취소
  void _unlike() {
    // 기존 좋아요 리스트를 복사
    final List likedUsers =
    List<String>.from(data['likedUsers'] ?? []);

    // 나를 추가
    likedUsers.remove(widget.user.email);

    // 업데이트할 항목을 문서로 준비
    final updateData = {
      'likedUsers': likedUsers,
    };

    FirebaseFirestore.instance
        .collection('post')
        .doc(widget.document.id)
        .update(updateData);
  }

  // 댓글 작성
  void _writeComment(String text) {
    final data = {
      'writer': widget.user.email,
      'comment': text,
    };

    // 댓글 추가
    FirebaseFirestore.instance
        .collection('post')
        .doc(widget.document.id)
        .collection('comment')
        .add(data);

    // 마지막 댓글과 댓글 수 갱신
    final updateData = {
      'lastComment': text,
      'commentCount': (data['commentCount'] as int? ?? 0) + 1,
    };

    FirebaseFirestore.instance
        .collection('post')
        .doc(widget.document.id)
        .update(updateData);

  }
}