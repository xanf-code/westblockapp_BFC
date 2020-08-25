import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Widgets/postWidget.dart';
import 'package:westblockapp/models/Users.dart';

class UserPosts extends StatefulWidget {
  final String userProfileId;

  const UserPosts({Key key, this.userProfileId}) : super(key: key);
  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  bool loading = false;
  List<Post> postList = [];
  void initState() {
    getAllProfilePosts();
  }

  displayProfilePosts() {
    if (loading) {
      return LinearProgressIndicator();
    } else if (postList.isEmpty) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                height: 300,
                width: 300,
                imageUrl:
                    "https://png.pngtree.com/svg/20161030/nodata_800056.png",
              ),
              Text(
                "oops it's empty :(",
                style: GoogleFonts.montserrat(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: postList,
    );
  }

  getAllProfilePosts() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await postReference
        .document(widget.userProfileId)
        .collection("usersPosts")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    setState(() {
      loading = false;
      postList = querySnapshot.documents
          .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text("User Posts"),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          displayProfilePosts(),
        ],
      ),
    );
  }
}
