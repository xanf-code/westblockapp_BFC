import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/models/Users.dart';

import 'Profile.dart';

class Watchpage extends StatefulWidget {
  final String title;
  final User gCurrentUser;

  const Watchpage({Key key, this.title, this.gCurrentUser}) : super(key: key);
  @override
  _WatchpageState createState() => _WatchpageState();
}

class _WatchpageState extends State<Watchpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text(widget.title),
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
        centerTitle: false,
      ),
      body: Center(
        child: Text('Watch Page'),
      ),
    );
  }
}
