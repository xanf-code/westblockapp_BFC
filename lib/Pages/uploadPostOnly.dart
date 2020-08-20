import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Widgets/AllpostWidgets.dart';
import 'package:westblockapp/models/Users.dart';

class PostOnlyPage extends StatefulWidget {
  final String title;
  final User gCurrentUser;

  const PostOnlyPage({Key key, this.title, this.gCurrentUser});
  @override
  _PostOnlyPageState createState() => _PostOnlyPageState();
}

class _PostOnlyPageState extends State<PostOnlyPage> {
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController postTextEditingController = TextEditingController();
  TextEditingController typeEditingController = TextEditingController();
  List<AllPosts> allposts = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  List<AllPosts> postList = [];
  File file;

  savePostToFirebase({String description, String type, String url}) {
    postReference
        .document(widget.gCurrentUser.id)
        .collection("usersPosts")
        .document(postId)
        .setData({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": timestamp,
      "likes": {},
      "description": description,
      "type": type,
      "url": url
    });
  }

  saveAllPostToFirebase({String description, String type, String url}) {
    AllPostsReference.document(postId).setData({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": timestamp,
      "likes": {},
      "description": description,
      "type": type,
      "url": url,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text("Post Page"),
        centerTitle: false,
      ),
      key: scaffoldKey,
      body: postWithoutPic(),
    );
  }

  postWithoutPic() {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          uploading ? CircularProgressIndicator() : Text(""),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(widget
                              .gCurrentUser.url ==
                          null
                      ? "https://upload.wikimedia.org/wikipedia/en/a/ac/West_Block_Blues_logo_transparent.png"
                      : widget.gCurrentUser.url),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  currentUser.username,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12, top: 12, bottom: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 10 * 24.0,
                  child: TextField(
                    controller: postTextEditingController,
                    maxLength: 400,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "Enter Post Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    maxLength: 10,
                    maxLines: null,
                    controller: typeEditingController,
                    style: GoogleFonts.montserrat(),
                    decoration: InputDecoration(
                      hintText: "Post Type",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: uploading
                          ? null
                          : () => controlPostOnlyUploadAndSave(),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Post to feed",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  controlPostOnlyUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    String downloadUrl = null;
    savePostToFirebase(
      url: downloadUrl,
      description: postTextEditingController.text,
      type: typeEditingController.text,
    );

    saveAllPostToFirebase(
      url: downloadUrl,
      description: postTextEditingController.text,
      type: typeEditingController.text,
    );

    postTextEditingController.clear();
    typeEditingController.clear();

    setState(() {
      uploading = false;
      postId = Uuid().v4();
    });
  }
}
