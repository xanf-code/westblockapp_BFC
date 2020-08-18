import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/Profile.dart';

class Followpage extends StatefulWidget {
  final String title;

  const Followpage({Key key, this.title}) : super(key: key);
  @override
  _FollowpageState createState() => _FollowpageState();
}

class _FollowpageState extends State<Followpage> {
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
        title: Text(this.widget.title),
        centerTitle: false,
      ),
      body: Center(
        child: Text('Follow Page'),
      ),
    );
  }
}
