import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/feedback.dart';
import 'package:westblockapp/models/Users.dart';

import 'Profile.dart';

class MorePage extends StatelessWidget {
  final User gCurrentUser;
  final String title;

  const MorePage({Key key, this.gCurrentUser, this.title}) : super(key: key);
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
                  backgroundImage: CachedNetworkImageProvider(gCurrentUser.url),
                ),
              ),
            ),
          )
        ],
        title: Text(this.title),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                    "https://i.ibb.co/f94hVg6/app5.png"),
              ),
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () =>
                    launch("https://www.bengalurufc.com/first-team/squad/"),
                child: Tiles(
                  icon: LineAwesomeIcons.male,
                  title: "Men's Team",
                ),
              ),
              Divider(
                height: 15,
                thickness: .3,
                color: Colors.white60,
              ),
              Tiles(
                icon: LineAwesomeIcons.female,
                title: "Women's Team",
              ),
              Divider(
                height: 15,
                thickness: .3,
                color: Colors.white60,
              ),
              GestureDetector(
                onTap: () =>
                    launch("https://www.bengalurufc.com/topics/bfc-b/"),
                child: Tiles(
                  icon: AntDesign.team,
                  title: "BFC B Team",
                ),
              ),
              Divider(
                height: 15,
                thickness: .3,
                color: Colors.white60,
              ),
              GestureDetector(
                onTap: () =>
                    launch("https://www.bengalurufc.com/topics/academy/"),
                child: Tiles(
                  icon: LineAwesomeIcons.child,
                  title: "Academy Team",
                ),
              ),
              Divider(
                height: 15,
                thickness: .3,
                color: Colors.white60,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => FeedbackForm(),
                  ),
                ),
                child: Tiles(
                  icon: LineAwesomeIcons.microphone,
                  title: "Feedback",
                ),
              ),
              Divider(
                height: 15,
                thickness: .3,
                color: Colors.white60,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Tiles extends StatelessWidget {
  final IconData icon;
  final String title;
  const Tiles({
    Key key,
    this.icon,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20,
        bottom: 15,
      ),
      child: Row(
        children: [
          Icon(
            this.icon,
            size: 30,
            color: Colors.white,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            this.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
