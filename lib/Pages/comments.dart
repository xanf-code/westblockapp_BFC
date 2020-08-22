import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postDescription;
  final String postType;

  CommentsPage(
      {this.postId, this.postOwnerId, this.postDescription, this.postType});

  @override
  CommentsPageState createState() => CommentsPageState(
      postId: postId,
      postOwnerId: postOwnerId,
      postDescription: postDescription,
      postType: postType);
}

class CommentsPageState extends State<CommentsPage> {
  final String postId;
  final String postOwnerId;
  final String postDescription;
  final String postType;
  TextEditingController commentTextEditingController = TextEditingController();

  CommentsPageState(
      {Key key,
      this.postId,
      this.postOwnerId,
      this.postDescription,
      this.postType});

  displayComments() {
    return StreamBuilder(
      stream: commentsReference
          .document(postId)
          .collection("comments")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document) {
          comments.add(Comment.fromDocument(document));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  saveComment() {
    commentsReference.document(postId).collection("comments").add({
      "username": currentUser.username,
      "comment": commentTextEditingController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "userId": currentUser.id,
    });
    bool isNotPostOwner = postOwnerId != currentUser.id;
    if (isNotPostOwner) {
      activityReference.document(postOwnerId).collection("feedItems").add({
        "activityType": "comment",
        "commentDate": timestamp,
        "postId": postId,
        "userId": currentUser.id,
        "username": currentUser.username,
        "userProfileImage": currentUser.url,
        "description": postDescription,
      });
    }
    commentTextEditingController.clear();
  }

  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text("Comments"),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: displayComments(),
            ),
            ListTile(
              title: TextFormField(
                validator: (String value) {
                  if (value.isEmpty) {
                    return "This field cannot be empty!";
                  } else {
                    return null;
                  }
                },
                controller: commentTextEditingController,
                decoration: InputDecoration(
                  labelText: "Add Comment Here",
                  labelStyle: TextStyle(),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
              trailing: FlatButton.icon(
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      saveComment();
                    }
                  });
                  //saveComment
                },
                icon: Icon(LineAwesomeIcons.send),
                label: Text("send"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String userName;
  final String userId;

  final String comment;
  final String url;
  final Timestamp timestamp;

  Comment({this.userName, this.userId, this.comment, this.url, this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot documentSnapshot) {
    return Comment(
      userName: documentSnapshot["username"],
      userId: documentSnapshot["userId"],
      comment: documentSnapshot["comment"],
      url: documentSnapshot["url"],
      timestamp: documentSnapshot["timestamp"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Container(
        child: Column(
          children: [
            ListTile(
              title: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "$userName ",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextSpan(
                    text: "$comment",
                    style: TextStyle(
                      color: Colors.grey[800],
                      height: 1.5,
                      letterSpacing: .7,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ]),
              ),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              subtitle: Text(
                tAgo.format(
                  timestamp.toDate(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
