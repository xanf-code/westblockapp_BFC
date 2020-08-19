import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/ProfileRoutes/editProfilePage.dart';
import 'package:westblockapp/Pages/ProfileRoutes/list.dart';
import 'package:westblockapp/Widgets/postWidget.dart';
import 'package:westblockapp/models/Users.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;

  const ProfilePage({Key key, this.userProfileId}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = false;
  List<Post> postList = [];
  void initState() {
    getAllProfilePosts();
  }

  createProfileTopView() {
    return FutureBuilder(
      future: usersReference.document(widget.userProfileId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return LinearProgressIndicator();
        }
        User user = User.fromDocument(dataSnapshot.data);
        return Padding(
          padding: EdgeInsets.all(17.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: CachedNetworkImageProvider(user.url),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.profileName,
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.email,
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
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

  logOutUser() {
    gSignIn.signOut();
  }

  profilePageButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    EditProfile(currentOnlineUser: currentUser.id),
              ),
            ),
            title: Text(
              "Edit Profile",
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: Icon(AntDesign.edit),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
          ),
          ListTile(
            leading: Icon(SimpleLineIcons.feed),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      UserPosts(userProfileId: currentUser.id),
                ),
              );
            },
            title: Text(
              "All Posts",
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListTile(
            leading: Icon(MaterialIcons.record_voice_over),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            title: Text(
              "Feedback",
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              logOutUser();
              Navigator.pop(context);
            },
            leading: Icon(SimpleLineIcons.logout),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
            title: Text(
              "Sign Out",
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text("Profile"),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          createProfileTopView(),
          Divider(),
          profilePageButtons(),
        ],
      ),
    );
  }
}
