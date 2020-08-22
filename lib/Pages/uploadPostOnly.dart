import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController onlyPostTextEditingController = TextEditingController();
  TextEditingController onlyTypeEditingController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  savePostToFirebase({String description, String type}) {
    postReference
        .document(widget.gCurrentUser.id)
        .collection("usersPosts")
        .document(postId)
        .setData({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": DateTime.now(),
      "likes": {},
      "description": description,
      "type": type,
    });
  }

  saveAllPostToFirebase({
    String description,
    String type,
  }) {
    AllPostsReference.document(postId).setData({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": DateTime.now(),
      "likes": {},
      "description": description,
      "type": type,
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

  var _formKey = GlobalKey<FormState>();

  postWithoutPic() {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          uploading ? LinearProgressIndicator() : Text(""),
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
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12, top: 12, bottom: 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 10 * 24.0,
                    child: TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field cannot be empty!";
                        } else {
                          return null;
                        }
                      },
                      controller: onlyPostTextEditingController,
                      maxLength: 400,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "Enter Post Description",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 15,
                          bottom: 11,
                          top: 11,
                          right: 15,
                        ),
                      ),
                    ),
                  ),
                ),
//              Padding(
//                padding: const EdgeInsets.only(left: 12.0, right: 12),
//                child: Container(
//                  width: MediaQuery.of(context).size.width,
//                  child: TextField(
//                    maxLength: 10,
//                    maxLines: null,
//                    controller: onlyTypeEditingController,
//                    style: GoogleFonts.montserrat(),
//                    decoration: InputDecoration(
//                      hintText: "Post Type",
//                      border: OutlineInputBorder(),
//                    ),
//                  ),
//                ),
//              ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: DropDownField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter(
                        RegExp("[a-zA-Z]"),
                      ),
                    ],
                    itemsVisibleInDropdown: 10,
                    hintText: "Select Tag",
                    controller: onlyTypeEditingController,
                    items: typeslist,
                    onValueChanged: (value) {
                      setState(() {
                        selectType = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              controlPostOnlyUploadAndSave();
                            }
                          });
                        },
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
          ),
        ],
      ),
    );
  }

  String selectType = "";
  List<String> typeslist = [
    "offtopic",
    "transfer",
    "general",
    "fan",
    "stories",
    "afc",
    "isl",
    "players",
    'fanart',
  ];

  bool loading = false;
  List<AllPosts> postList = [];

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

  controlPostOnlyUploadAndSave() async {
    savePostToFirebase(
      description: onlyPostTextEditingController.text,
      type: onlyTypeEditingController.text,
    );

    saveAllPostToFirebase(
      description: onlyPostTextEditingController.text,
      type: onlyTypeEditingController.text,
    );

    onlyPostTextEditingController.clear();
    onlyTypeEditingController.clear();
    Navigator.pop(context);

    setState(() {
      uploading = false;
      postId = Uuid().v4();
    });
  }
}
