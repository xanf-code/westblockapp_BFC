import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:westblockapp/Pages/Follow.dart';
import 'package:westblockapp/Pages/connect.dart';
import 'package:westblockapp/Pages/shop.dart';
import 'package:westblockapp/Pages/watch.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        Followpage(title: 'Follow'),
        Watchpage(title: 'Watch'),
        Connectpage(title: 'Connect'),
        Shoppage(title: 'Shop'),
      ][currentIndex],
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Color(0xFF011589),
        iconSize: 22,
        opacity: 0,
        currentIndex: currentIndex,
        onTap: changePage,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Ionicons.ios_football, color: Colors.white70),
            activeIcon: Icon(Ionicons.ios_football, color: Colors.white),
            title: Text("Follow"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Feather.play_circle, color: Colors.white70),
            activeIcon: Icon(Feather.play_circle, color: Colors.white),
            title: Text("Watch"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.chat_bubble_outline, color: Colors.white70),
            activeIcon: Icon(Icons.chat_bubble_outline, color: Colors.white),
            title: Text("Connect"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Feather.shopping_bag, color: Colors.white70),
            activeIcon: Icon(Feather.shopping_bag, color: Colors.white),
            title: Text("Shop"),
          ),
        ],
        elevation: 8,
      ),
    );
  }
}
