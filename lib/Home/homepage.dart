import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:westblockapp/Pages/CreateAccount.dart';
import 'package:westblockapp/Pages/Follow.dart';
import 'package:westblockapp/Pages/connect.dart';
import 'package:westblockapp/Pages/shop.dart';
import 'package:westblockapp/Pages/watch.dart';
import 'package:westblockapp/models/Users.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection("users");
final postReference = Firestore.instance.collection("posts");
final activityReference = Firestore.instance.collection("feed");
final commentsReference = Firestore.instance.collection("comments");
final AllPostsReference = Firestore.instance.collection("allPosts");
final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Posts Pictures");

final DateTime timestamp = DateTime.now();
User currentUser;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isSignedIn = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      ControllSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error :" + gError);
    });
    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      ControllSignIn(gSignInAccount);
    }).catchError((onError) {
      print("Error" + onError);
    });
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  ControllSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveUserToFirebase();
      setState(() {
        _isSignedIn = true;
      });
    } else {
      setState(() {
        _isSignedIn = false;
      });
    }
  }

  saveUserToFirebase() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersReference.document(gCurrentUser.id).get();
    if (!documentSnapshot.exists) {
      final username = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CreateAccountPage(),
        ),
      );
      usersReference.document(gCurrentUser.id).setData({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "username": username,
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "timestamp": timestamp,
      });
      documentSnapshot = await usersReference.document(gCurrentUser.id).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
  }

  loginUser() {
    gSignIn.signIn();
  }

  logOutUser() {
    gSignIn.signOut();
  }

  Scaffold HomePage() {
    return Scaffold(
      body: <Widget>[
        Followpage(
          title: 'Follow',
          gCurrentUser: currentUser,
        ),
        Watchpage(
          title: 'Watch',
          gCurrentUser: currentUser,
        ),
        Connectpage(
          title: 'Connect',
          gCurrentUser: currentUser,
        ),
        Shoppage(
          title: 'Shop',
          gCurrentUser: currentUser,
        ),
      ][currentIndex],
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Color(0xFF011589),
        iconSize: 22,
        opacity: 0,
        currentIndex: currentIndex,
        onTap: changePage,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Ionicons.ios_football, color: Colors.white70),
            activeIcon: Icon(Ionicons.ios_football, color: Colors.white),
            title: Text("Follow"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(LineAwesomeIcons.play, color: Colors.white70),
            activeIcon: Icon(LineAwesomeIcons.play, color: Colors.white),
            title: Text("Watch"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.chat_bubble_outline, color: Colors.white70),
            activeIcon: Icon(Icons.chat_bubble_outline, color: Colors.white),
            title: Text("Connect"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Feather.shopping_bag, color: Colors.white70),
            activeIcon: Icon(Feather.shopping_bag, color: Colors.white),
            title: Text("Shop"),
          ),
        ],
        elevation: 8,
      ),
    );
  }

  Scaffold SignInPage() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: loginUser,
              color: Colors.deepPurple,
              child: Text(
                "Google SignIn",
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return HomePage();
    } else {
      return SignInPage();
    }
  }
}
