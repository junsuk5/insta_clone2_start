import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePage extends StatefulWidget {
//  final FirebaseUser user;

//  CreatePage(this.user);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getImage();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  File _image;

  // 갤러리에서 사진 가져오기
  Future _getImage() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('새 게시물'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _uploadFile(context);
          },
          child: Text('공유'),
        )
      ],
    );
  }

  Future _uploadFile(BuildContext context) async {
    // 스토리지에 업로드할 파일 경로

    // 파일 업로드

    // 완료까지 기다림

    // 업로드 완료 후 url

    // 문서 작성

    // 완료 후 앞 화면으로 이동
    Navigator.pop(context);
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                _buildImage(),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: '문구 입력...',
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Text('사람 태그하기'),
          ),
          Divider(),
          ListTile(
            leading: Text('위치 추가하기'),
          ),
          Divider(),
          _buildLocation(),
          ListTile(
            leading: Text('위치 추가하기'),
          ),
          ListTile(
            leading: Text('Facebook'),
            trailing: Switch(
              value: false,
              onChanged: (bool value) {},
            ),
          ),
          ListTile(
            leading: Text('Twitter'),
            trailing: Switch(
              value: false,
              onChanged: (bool value) {},
            ),
          ),
          ListTile(
            leading: Text('Tumblr'),
            trailing: Switch(
              value: false,
              onChanged: (bool value) {},
            ),
          ),
          Divider(),
          ListTile(
            leading: Text(
              '고급 설정',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return _image == null
        ? Text('No Image')
        : Image.file(
            _image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          );
  }

  Widget _buildLocation() {
    final locationItems = [
      '꿈두레 도서관',
      '경기도 오산',
      '오산세교',
      '동탄2신도시',
      '동탄',
      '검색',
    ];
    return SizedBox(
      height: 34.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: locationItems.map((location) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Chip(
              label: Text(
                location,
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
