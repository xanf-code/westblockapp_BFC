import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:westblockapp/Home/homepage.dart';

import 'Profile.dart';

class Shoppage extends StatefulWidget {
  final String title;

  const Shoppage({Key key, this.title}) : super(key: key);
  @override
  _ShoppageState createState() => _ShoppageState();
}

class _ShoppageState extends State<Shoppage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      ProfilePage(userProfileId: currentUser.id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(Icons.account_circle),
            ),
          )
        ],
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: Center(
        child: Text('Shop Page'),
      ),
    );
  }
}
