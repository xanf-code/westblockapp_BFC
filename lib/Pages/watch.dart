import 'package:flutter/material.dart';

class Watchpage extends StatefulWidget {
  final String title;

  const Watchpage({Key key, this.title}) : super(key: key);
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
        centerTitle: false,
      ),
      body: Center(
        child: Text('Watch Page'),
      ),
    );
  }
}
