import 'package:flutter/material.dart';

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
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: Center(
        child: Text('Shop Page'),
      ),
    );
  }
}
