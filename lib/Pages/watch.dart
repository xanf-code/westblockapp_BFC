import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/VideoDescription/descriptionPage.dart';
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
  Future<String> WBTVdata() async {
    var url = 'https://freshoftheblock.herokuapp.com/';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        data = jsonResponse;
      });
    } else {
      CircularProgressIndicator();
    }
  }

  Future<String> FOTBdata() async {
    var url = 'https://westblocktv.herokuapp.com/';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        fotbdata = jsonResponse;
      });
    } else {
      CircularProgressIndicator();
    }
  }

  @override
  void initState() {
    WBTVdata();
    FOTBdata();
    super.initState();
  }

  List data;
  List fotbdata;
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
      body: ListView(
        children: [
          CarouselTop(),
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              left: 10,
            ),
            child: Text(
              "Fresh off the Block",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF011589),
              ),
            ),
          ),
          FreshOfftheBlock(),
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              left: 10,
            ),
            child: Text(
              "West block TV",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF011589),
              ),
            ),
          ),
          WestBlockTV(),
        ],
      ),
    );
  }

  Container WestBlockTV() {
    return Container(
      height: 280,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: fotbdata == null ? 0 : fotbdata.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DescPage(
                            title: fotbdata[index]["snippet"]["title"],
                            desc: fotbdata[index]["snippet"]["description"],
                            videoId: fotbdata[index]["contentDetails"]
                                ["videoId"],
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: 260,
                            width: 190,
                            margin: EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 5,
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: fotbdata[index]["snippet"]["thumbnails"]
                                          ["maxres"] ==
                                      null
                                  ? "https://ss.thgim.com/football/article30810548.ece/alternates/FREE_380/bengaluru-fcjpg"
                                  : fotbdata[index]["snippet"]["thumbnails"]
                                      ["maxres"]["url"],
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 0,
                            child: Container(
                                height: 40,
                                width: 40,
                                color: Color(0xFF0033ff),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container FreshOfftheBlock() {
    return Container(
      height: 280,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DescPage(
                            title: data[index]["snippet"]["title"],
                            desc: data[index]["snippet"]["description"],
                            videoId: data[index]["contentDetails"]["videoId"],
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: 260,
                            width: 190,
                            margin: EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 5,
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: data[index]["snippet"]["thumbnails"]
                                          ["maxres"] ==
                                      null
                                  ? "https://ss.thgim.com/football/article30810548.ece/alternates/FREE_380/bengaluru-fcjpg"
                                  : data[index]["snippet"]["thumbnails"]
                                      ["maxres"]["url"],
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 0,
                            child: Container(
                                height: 40,
                                width: 40,
                                color: Color(0xFF0033ff),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container CarouselTop() {
    return Container(
      height: 300,
      child: Carousel(
        images: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl:
                "https://e00-marca.uecdn.es/assets/multimedia/imagenes/2017/06/28/14986550187048.jpg",
          ),
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl:
                "https://www.thenewsminute.com/sites/default/files/styles/news_detail/public/Bengaluru%20FC%20banners%20750.jpg?itok=NcQ9aliX",
          ),
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl:
                "https://e00-marca.uecdn.es/assets/multimedia/imagenes/2017/06/28/14986550559577.jpg",
          ),
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl:
                "https://sportstar.thehindu.com/football/football-photos/article20911106.ece/ALTERNATES/LANDSCAPE_590/bengaluur%20fcjpg",
          ),
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl:
                "https://e00-marca.uecdn.es/assets/multimedia/imagenes/2017/06/28/14986550286465.jpg",
          ),
        ],
        animationCurve: Curves.easeIn,
        autoplay: false,
        dotSize: 4.0,
        dotSpacing: 15.0,
        dotColor: Colors.white,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.transparent,
      ),
    );
  }
}
