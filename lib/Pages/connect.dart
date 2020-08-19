import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/Profile.dart';
import 'package:westblockapp/Widgets/AllpostWidgets.dart';
import 'package:westblockapp/models/Users.dart';

class Connectpage extends StatefulWidget {
  final String title;
  final User gCurrentUser;

  const Connectpage({Key key, this.title, this.gCurrentUser});
  @override
  _ConnectpageState createState() => _ConnectpageState();
}

class _ConnectpageState extends State<Connectpage> {
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController postTextEditingController = TextEditingController();
  TextEditingController typeEditingController = TextEditingController();
  List<AllPosts> allposts = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  getAllPosts() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot =
        await AllPostsReference.orderBy("timestamp", descending: true)
            .getDocuments();

    setState(() {
      loading = false;
      postList = querySnapshot.documents
          .map((documentSnapshot) => AllPosts.fromDocument(documentSnapshot))
          .toList();
    });
  }

  createFeed() {
    if (allposts == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
        physics: BouncingScrollPhysics(),
        children: postList,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  controllUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    savePostToFirebase(
      description: postTextEditingController.text,
      type: typeEditingController.text,
    );

    saveAllPostToFirebase(
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

  savePostToFirebase({String description, String type}) {
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
      "type": type
    });
  }

  saveAllPostToFirebase({String description, String type}) {
    AllPostsReference.document(postId).setData({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": timestamp,
      "likes": {},
      "description": description,
      "type": type
    });
  }

  uploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text("Post"),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget
                            .gCurrentUser.url ==
                        null
                    ? "https://upload.wikimedia.org/wikipedia/en/a/ac/West_Block_Blues_logo_transparent.png"
                    : widget.gCurrentUser.url),
              ),
              Container(
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: postTextEditingController,
                  style: GoogleFonts.montserrat(),
                  decoration: InputDecoration(
                      hintText: "Write Here", border: InputBorder.none),
                ),
              ),
              Container(
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: typeEditingController,
                  style: GoogleFonts.montserrat(),
                  decoration: InputDecoration(
                      hintText: "Post Type", border: InputBorder.none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: FlatButton(
                  onPressed: () {
                    controllUploadAndSave();
                  },
                  color: Colors.grey,
                  child: Text(
                    "Post",
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool loading = false;
  List<AllPosts> postList = [];

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
        title: Text(this.widget.title),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat_bubble_outline),
        backgroundColor: Colors.black,
        onPressed: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => uploadForm(),
          ),
        ),
      ),
      key: scaffoldKey,
      body: createFeed(),
    );
  }
}
