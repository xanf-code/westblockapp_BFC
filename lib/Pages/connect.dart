import 'package:flutter/material.dart';

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
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: Center(
        child: Text('Connect Page'),
      ),
    );
  }
}
