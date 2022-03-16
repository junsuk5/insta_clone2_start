import 'package:flutter/material.dart';

class CommentPage extends StatelessWidget {
  final document;

  CommentPage(this.document);

  final dummyItems = [
    {
      'writer': '아무개',
      'comment': '더미 댓글',
    },
    {
      'writer': '아무개',
      'comment': '더미 댓글',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('댓글'),
      ),
      body: ListView(
        children: dummyItems.map((doc) {
          return ListTile(
            leading: Text(doc['writer']),
            title: Text(doc['comment']),
          );
        }).toList(),
      ),
    );
  }

}
