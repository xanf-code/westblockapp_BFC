import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:westblockapp/Pages/CreateAccount.dart';
import 'package:westblockapp/Pages/Follow.dart';
import 'package:westblockapp/Pages/connect.dart';
import 'package:westblockapp/Pages/more.dart';
import 'package:westblockapp/Pages/shop.dart';
import 'package:westblockapp/Pages/watch.dart';
import 'package:westblockapp/models/Users.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection("users");
final postReference = Firestore.instance.collection("posts");
final activityReference = Firestore.instance.collection("feed");
final commentsReference = Firestore.instance.collection("comments");
final allPostsReference = Firestore.instance.collection("allPosts");
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
    _controller = PersistentTabController(initialIndex: 0);
    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error :" + gError);
    });
    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((onError) {
      print("Error" + onError);
    });
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
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

  PersistentTabController _controller;

  List<Widget> _buildScreens() {
    return [
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
      MorePage(
        title: 'More',
        gCurrentUser: currentUser,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Ionicons.ios_football,
          size: 22,
        ),
        title: ("Follow"),
        activeColor: CupertinoColors.white,
        inactiveColor: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          LineAwesomeIcons.play,
          size: 22,
        ),
        title: ("Watch"),
        activeColor: CupertinoColors.white,
        inactiveColor: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.chat_bubble_outline,
          size: 22,
        ),
        title: ("Connect"),
        activeColor: CupertinoColors.white,
        inactiveColor: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Feather.shopping_bag,
          size: 22,
        ),
        title: ("Shop"),
        activeColor: CupertinoColors.white,
        inactiveColor: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          MaterialCommunityIcons.dots_horizontal_circle_outline,
          size: 22,
        ),
        title: ("More"),
        activeColor: CupertinoColors.white,
        inactiveColor: Colors.white70,
      ),
    ];
  }

  Widget homePage() {
    return PersistentTabView(
      navBarHeight: 60,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Color(0xFF011589),
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: false,
      ),
      navBarStyle: NavBarStyle.style9,
      //3,9
    );
  }

  Scaffold signInPage() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Please sign up using Google to continue using our app.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 150,
              width: 300,
              child: CachedNetworkImage(
                imageUrl:
                    "https://upload.wikimedia.org/wikipedia/en/a/ac/West_Block_Blues_logo_transparent.png",
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Enter via Google Sign up",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 180,
                  height: 60,
                  child: RaisedButton(
                    color: Color(0xFF76A9EA),
                    child: CachedNetworkImage(
                        height: 30,
                        imageUrl:
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png"),
                    onPressed: loginUser,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return homePage();
    } else {
      return SafeArea(
        child: signInPage(),
      );
    }
  }
}
