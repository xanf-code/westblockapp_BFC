import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/Profile.dart';
import 'package:westblockapp/models/Users.dart';

class Followpage extends StatefulWidget {
  final String title;
  final User gCurrentUser;

  const Followpage({Key key, this.title, this.gCurrentUser}) : super(key: key);
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
              child: CircleAvatar(
                backgroundColor: Colors.yellow,
                radius: 17,
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.gCurrentUser.url),
                ),
              ),
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
