import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

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
        title: Text(this.widget.title),
        centerTitle: false,
      ),
      body: Center(
        child: Text('Follow Page'),
      ),
    );
  }
}
