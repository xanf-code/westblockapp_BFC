import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/Profile.dart';
import 'package:westblockapp/Pages/uploadPostOnly.dart';
import 'package:westblockapp/Widgets/AllpostWidgets.dart';
import 'package:westblockapp/models/Users.dart';
import 'package:image/image.dart' as ImD;

class Connectpage extends StatefulWidget {
  final String title;
  final User gCurrentUser;

  const Connectpage({Key key, this.title, this.gCurrentUser});
  @override
  _ConnectpageState createState() => _ConnectpageState();
}

class _ConnectpageState extends State<Connectpage>
    with AutomaticKeepAliveClientMixin<Connectpage> {
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController postTextEditingController = TextEditingController();
  TextEditingController typeEditingController = TextEditingController();
  List<AllPosts> allposts = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  List<AllPosts> postList = [];
  File file;

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
    if (loading) {
      return Center(
        child: LinearProgressIndicator(),
      );
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
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: postList,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(
        ImD.encodeJpg(mImageFile, quality: 75),
      );
    setState(() {
      file = compressedImageFile;
    });
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    await compressingPhoto();

    String downloadUrl = await uploadPhoto(file);

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
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  savePostToFirebase({String description, String type, String url}) {
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
      "url": url
    });
  }

  saveAllPostToFirebase({String description, String type, String url}) {
    AllPostsReference.document(postId).setData({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": DateTime.now(),
      "likes": {},
      "description": description,
      "type": type,
      "url": url,
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        storageReference.child("post_$postId.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadForm() {
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
          Column(
            children: [
              Container(
                height: 230,
                width: MediaQuery.of(context).size.width * .8,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(file),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
                      onTap: uploading ? null : () => controlUploadAndSave(),
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

  bool get wantKeepAlive => true;

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
      key: scaffoldKey,
      body: file == null ? timeline() : uploadForm(),
    );
  }

  timeline() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => takeImage(context),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            CachedNetworkImageProvider(currentUser.url),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("What\'s on your mind?"),
                    ],
                  ),
                  Center(
                    child: FlatButton.icon(
                      icon: Icon(MaterialCommunityIcons.format_quote_open),
                      label: Text("Post"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          createFeed(),
        ],
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("New Post"),
          children: [
            SimpleDialogOption(
              child: Text("Post without picture"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => PostOnlyPage(
                      gCurrentUser: currentUser,
                    ),
                  ),
                );
              },
            ),
            SimpleDialogOption(
              onPressed: pickFromGallery,
              child: Text("Pick From Gallery"),
            ),
          ],
        );
      },
    );
  }

  pickFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      maxWidth: 700,
      maxHeight: 700,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
        toolbarColor: Color(0xFF011589),
        statusBarColor: Color(0xFF011589),
        backgroundColor: Colors.white,
      ),
    );
    setState(() {
      this.file = croppedImage;
    });
  }
}
