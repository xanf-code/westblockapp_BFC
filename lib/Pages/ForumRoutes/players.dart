import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/Profile.dart';
import 'package:westblockapp/Widgets/AllpostWidgets.dart';
import 'package:westblockapp/models/Users.dart';
import 'package:image/image.dart' as ImD;

class PlayersForumpage extends StatefulWidget {
  final String title;
  final User gCurrentUser;

  const PlayersForumpage({Key key, this.title, this.gCurrentUser});
  @override
  _PlayersForumpageState createState() => _PlayersForumpageState();
}

class _PlayersForumpageState extends State<PlayersForumpage> {
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController postTextEditingController = TextEditingController();
  TextEditingController typeEditingController = TextEditingController();
  List<AllPosts> allposts = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  List<AllPosts> postList = [];
  File file;

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  getAllPosts() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await allPostsReference
        .where("type", isEqualTo: "players")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    setState(() {
      loading = false;
      postList = querySnapshot.documents
          .map((documentSnapshot) => AllPosts.fromDocument(documentSnapshot))
          .toList();
    });
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
      getAllPosts();
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
    allPostsReference.document(postId).setData({
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
      body: Form(
        child: ListView(
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
                Visibility(
                  visible: false,
                  child: TextFormField(
                    controller: typeEditingController..text = "players",
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
      ),
    );
  }

  topWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(widget
                              .gCurrentUser.url ==
                          null
                      ? "https://upload.wikimedia.org/wikipedia/en/a/ac/West_Block_Blues_logo_transparent.png"
                      : widget.gCurrentUser.url),
                  radius: 20,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "This field cannot be empty!";
                      } else {
                        return null;
                      }
                    },
                    controller: onlyPostTextEditingController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: false,
              child: TextFormField(
                controller: onlyTypeEditingController..text = "players",
              ),
            ),
            Divider(
              height: 10,
              thickness: 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton.icon(
                  onPressed: () => pickFromGallery(),
                  icon: Icon(LineAwesomeIcons.file_photo_o),
                  label: Text("Photo"),
                ),
                FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      if (_formKey.currentState.validate()) {
                        controlPostOnlyUploadAndSave();
                        getAllPosts();
                      }
                    });
                  },
                  icon: Icon(LineAwesomeIcons.pencil),
                  label: Text("Post"),
                ),
              ],
            ),
            Divider(
              thickness: .5,
            ),
          ],
        ),
      ),
    );
  }

  timeline() {
    return ListView(
      children: [
        topWidget(),
        createFeed(),
      ],
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text(this.widget.title),
        centerTitle: false,
      ),
      key: scaffoldKey,
      body: RefreshIndicator(
        child: file == null ? timeline() : uploadForm(),
        onRefresh: () => getAllPosts(),
      ),
    );
  }

  var _formKey = GlobalKey<FormState>();
  TextEditingController onlyPostTextEditingController = TextEditingController();
  TextEditingController onlyTypeEditingController = TextEditingController();

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

    setState(() {
      uploading = false;
      postId = Uuid().v4();
    });
  }

  pickFromGallery() async {
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
