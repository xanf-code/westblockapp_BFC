import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text("Comments"),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: displayComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentTextEditingController,
              decoration: InputDecoration(
                labelText: "Comment Here",
                labelStyle: GoogleFonts.montserrat(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            trailing: OutlineButton(
              onPressed: saveComment,
              child: Text(
                "Publish",
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
        ],
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
                    text: "$userName",
                    style: GoogleFonts.montserrat(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ":    ",
                    style: GoogleFonts.montserrat(color: Colors.black),
                  ),
                  TextSpan(
                    text: "$comment",
                    style: GoogleFonts.montserrat(color: Colors.black),
                  ),
                ]),
              ),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(url),
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
