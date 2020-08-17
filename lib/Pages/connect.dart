import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:westblockapp/Widgets/UserImageWidget.dart';

import 'Profile.dart';

class Connectpage extends StatefulWidget {
  final String title;

  const Connectpage({Key key, this.title}) : super(key: key);
  @override
  _ConnectpageState createState() => _ConnectpageState();
}

class _ConnectpageState extends State<Connectpage> {
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
                  builder: (context) => ProfilePage(),
                ),
              );
            },
            child: UserPhoto(),
          )
        ],
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: Center(
        child: Text('Connect Page'),
      ),
    );
  }
}
