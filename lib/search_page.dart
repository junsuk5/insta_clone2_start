import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'create_page.dart';
import 'detail_post_page.dart';

class SearchPage extends StatelessWidget {
//  final FirebaseUser user;

//  SearchPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Instagram Clone',
        style: GoogleFonts.pacifico(),
      ),
    );
  }

  Widget _buildBody(context) {
    print('search_page created');
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return _buildListItem();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.create),
        onPressed: () {
          print('눌림');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CreatePage()));
        },
      ),
    );
  }

  Widget _buildListItem() {
    return Image.network(
      '',
      fit: BoxFit.cover,
    );
  }
}
