import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/comments.dart';
import 'package:westblockapp/models/Users.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  //final String timestamp;
  final dynamic likes;
  final String description;
  final String type;

  Post(
      {this.postId,
      this.ownerId,
      //this.timestamp,
      this.likes,
      this.description,
      this.type});

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerId"],
      likes: documentSnapshot["likes"],
      description: documentSnapshot["description"],
      type: documentSnapshot["type"],
    );
  }

  int getTotlaNumberOfLikes(likes) {
    if (likes == null) {
      return 0;
    }

    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        //timestamp: this.timestamp,
        likes: this.likes,
        description: this.description,
        type: this.type,
        likeCount: getTotlaNumberOfLikes(this.likes),
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  //final String timestamp;
  Map likes;
  final String description;
  final String type;
  int likeCount;
  bool isLiked;
  bool showfire = false;
  final String currentUserOnlineId = currentUser?.id;

  _PostState(
      {this.postId,
      this.ownerId,
      //this.timestamp,
      this.likes,
      this.description,
      this.type,
      this.likeCount});
  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserOnlineId] == true);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            createPostHead(),
            Divider(),
            createPostDesc(),
            Divider(),
            createPostFooter(),
          ],
        ),
      ),
    );
  }

  createPostHead() {
    return FutureBuilder(
      future: usersReference.document(ownerId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return CircularProgressIndicator();
        }
        User user = User.fromDocument(dataSnapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.url),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            user.profileName,
            style:
                GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        );
      },
    );
  }

  removeLike() {
    bool isnotpostowner = currentUserOnlineId != ownerId;

    if (isnotpostowner) {
      activityReference
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .get()
          .then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
    }
  }

  addLike() {
    bool isnotpostowner = currentUserOnlineId != ownerId;
    if (isnotpostowner) {
      activityReference
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .setData({
        "activityType": "like",
        "username": currentUser.username,
        "userId": currentUser.id,
        "timestamp": timestamp,
        "description": description,
        "type": type,
        "postId": postId,
        "userProfileImg": currentUser.url
      });
    }
  }

  controllUserLikedPost() {
    bool _liked = likes[currentUserOnlineId] == true;

    if (_liked) {
      postReference
          .document(ownerId)
          .collection("usersPosts")
          .document(postId)
          .updateData({"likes.$currentUserOnlineId": false});
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        likes[currentUserOnlineId] = false;
      });
    } else if (!_liked) {
      postReference
          .document(ownerId)
          .collection("usersPosts")
          .document(postId)
          .updateData({"likes.$currentUserOnlineId": true});
      addLike();
      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        likes[currentUserOnlineId] = true;
        showfire = true;
      });
    }
  }

  createPostDesc() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type),
          Text(description),
        ],
      ),
    );
  }

  createPostFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, bottom: 20),
              child: GestureDetector(
                onTap: () => controllUserLikedPost(),
                //child: Icon(SimpleLineIcons.fire),
                child: isLiked
                    ? Icon(
                        SimpleLineIcons.fire,
                        color: Colors.red,
                      )
                    : Icon(SimpleLineIcons.fire),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10, bottom: 20),
              child: Text(
                "$likeCount likes",
                style: GoogleFonts.montserrat(fontSize: 14),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, bottom: 20),
              child: GestureDetector(
                onTap: () => displayComments(
                  context,
                  postId: postId,
                  ownerId: ownerId,
                  description: description,
                  type: type,
                ),
                child: Icon(
                  Octicons.comment_discussion,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  displayComments(BuildContext context,
      {String postId, String ownerId, String description, String type}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CommentsPage(
            postId: postId,
            postOwnerId: ownerId,
            postDescription: description,
            postType: type),
      ),
    );
  }
}
