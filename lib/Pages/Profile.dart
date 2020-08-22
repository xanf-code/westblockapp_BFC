import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
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
          padding: EdgeInsets.only(top: 30.0, bottom: 15),
          child: Column(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: CachedNetworkImageProvider(user.url),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
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
                          color: Colors.grey[500],
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
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) =>
                  EditProfile(currentOnlineUser: currentUser.id),
            ),
          ),
          child: buttons(
            icon: LineAwesomeIcons.pencil_square_o,
            text: "Edit Profile",
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => UserPosts(userProfileId: currentUser.id),
              ),
            );
          },
          child: buttons(
            icon: LineAwesomeIcons.history,
            text: "Post History",
          ),
        ),
        buttons(
          icon: LineAwesomeIcons.cog,
          text: "Settings",
        ),
        buttons(
          icon: LineAwesomeIcons.user_plus,
          text: "Invite a Friend",
        ),
        buttons(
          icon: LineAwesomeIcons.question_circle,
          text: "Help & Support",
        ),
        buttons(
          icon: LineAwesomeIcons.user_secret,
          text: "Privacy",
        ),
        GestureDetector(
          onTap: () {
            logOutUser();
            Navigator.pop(context);
          },
          child: buttons(
            icon: LineAwesomeIcons.sign_out,
            text: "Logout",
          ),
        ),
      ],
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
        physics: BouncingScrollPhysics(),
        children: [
          createProfileTopView(),
          profilePageButtons(),
        ],
      ),
    );
  }
}

class buttons extends StatelessWidget {
  final IconData icon;
  final String text;
  const buttons({
    Key key,
    this.icon,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10 * 5.5,
      margin: EdgeInsets.symmetric(
        horizontal: 10 * 4.0,
      ).copyWith(bottom: 10 * 2.0),
      decoration: BoxDecoration(
        color: Color(0xFFF3F7FB),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Row(
          children: [
            Icon(
              this.icon,
              size: 10 * 2.5,
            ),
            SizedBox(
              width: 10 * 2.5,
            ),
            Text(
              this.text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              SimpleLineIcons.arrow_right,
              size: 10,
            ),
          ],
        ),
      ),
    );
  }
}
