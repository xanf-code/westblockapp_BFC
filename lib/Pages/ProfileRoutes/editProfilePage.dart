import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/models/Users.dart';

class EditProfile extends StatefulWidget {
  final String currentOnlineUser;

  const EditProfile({Key key, this.currentOnlineUser}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameTextEditingController = TextEditingController();
  final _sacffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _profileNameValid = true;

  void init() {
    super.initState();
    getAndDisplayInfo();
  }

  getAndDisplayInfo() async {
    setState(() {
      loading = true;
    });
    DocumentSnapshot documentSnapshot =
        await usersReference.document(widget.currentOnlineUser).get();
    user = User.fromDocument(documentSnapshot);

    nameTextEditingController.text = user.username;

    setState(() {
      loading = false;
    });
  }

  updateUserName() {
    setState(() {
      nameTextEditingController.text.trim().length < 5 ||
              nameTextEditingController.text.isEmpty
          ? _profileNameValid = false
          : _profileNameValid = true;
    });
    if (_profileNameValid) {
      usersReference
          .document(widget.currentOnlineUser)
          .updateData({"username": nameTextEditingController.text});

      SnackBar success = SnackBar(
        content: Text("Username Updated"),
      );
      _sacffoldKey.currentState.showSnackBar(success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sacffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text("Edit Profile"),
        centerTitle: false,
      ),
      body: loading
          ? LinearProgressIndicator()
          : ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 15,
                          bottom: 7,
                        ),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundImage:
                              CachedNetworkImageProvider(currentUser.url),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            createProfileNameTextField(),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 29.0,
                                left: 50,
                                right: 50,
                              ),
                              child: RaisedButton(
                                onPressed: updateUserName,
                                child: Text("Update"),
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

  createProfileNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: Text("Edit Profile Name"),
        ),
        TextField(
          inputFormatters: [
            WhitelistingTextInputFormatter(
              RegExp("[a-zA-Z]"),
            ),
          ],
          controller: nameTextEditingController,
          decoration: InputDecoration(
            hintText: "New User Name",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintStyle: TextStyle(color: Colors.grey),
            errorText: _profileNameValid ? null : "Too Short",
          ),
        ),
      ],
    );
  }
}
