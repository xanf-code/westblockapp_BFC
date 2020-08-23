import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/models/Users.dart';

import 'Profile.dart';

class Shoppage extends StatefulWidget {
  final String title;
  final User gCurrentUser;

  const Shoppage({Key key, this.title, this.gCurrentUser}) : super(key: key);

  @override
  _ShoppageState createState() => _ShoppageState();
}

class _ShoppageState extends State<Shoppage> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
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
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: shopWidget(orientation: orientation),
    );
  }
}

class shopWidget extends StatelessWidget {
  const shopWidget({
    Key key,
    @required this.orientation,
  }) : super(key: key);

  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("merchtopimage").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 450,
                  floating: false,
                  pinned: false,
                  backgroundColor: Colors.white,
                  //snapshot.data.documents[index]["image"]
                  //snapshot.data.documents.length
                  flexibleSpace: PageView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, i) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return PageView(
                          children: [
                            CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: snapshot.data.documents[i]["image"],
                            )
                          ],
                        );
                      }
                    },
                  ),
                ),
              ];
            },
            body: StreamBuilder(
              stream: Firestore.instance
                  .collection("merch")
                  .orderBy("id", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          itemCount: snapshot.data.documents.length,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 0.75,
                                  crossAxisCount:
                                      (orientation == Orientation.portrait)
                                          ? 2
                                          : 3),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  height: 180,
                                  width: 180,
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data.documents[index]
                                        ['pic'],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data.documents[index]['title'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff010c8a),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () => launch(
                                    "${snapshot.data.documents[index]["clicklink"]}",
                                  ),
                                  child: Container(
                                    height: 43,
                                    width:
                                        MediaQuery.of(context).size.width * .4,
                                    decoration: BoxDecoration(
                                      color: Color(0xff010c8a),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "SHOP NOW",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
