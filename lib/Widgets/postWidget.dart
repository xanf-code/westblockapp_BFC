import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/comments.dart';
import 'package:westblockapp/models/Users.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String url;
  //final String timestamp;
  final dynamic likes;
  final String description;
  final String type;

  Post({
    this.postId,
    this.ownerId,
    //this.timestamp,
    this.likes,
    this.description,
    this.type,
    this.url,
  });

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerId"],
      likes: documentSnapshot["likes"],
      description: documentSnapshot["description"],
      type: documentSnapshot["type"],
      url: documentSnapshot["url"],
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
        url: this.url,
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
  final String url;
  final String description;
  final String type;
  int likeCount;
  bool isLiked;
  bool showfire = false;
  final String currentUserOnlineId = currentUser?.id;

  _PostState(
      {this.postId,
      this.url,
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
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          createPostHead(),
          createPostBody(),
          createPostDesc(),
          Divider(),
          UpvoteButton(),
          Divider()
        ],
      ),
    );
  }

  bool _isImageShown = false;

  createPostBody() {
    return Stack(
      children: <Widget>[
        !_isImageShown
            ? Center(
                child: GestureDetector(
                  onTap: () => setState(() => _isImageShown = !_isImageShown),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 8),
                    child: url != null
                        ? Container(
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(url),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ),
              )
            : SizedBox(),
        _isImageShown
            ? GestureDetector(
                onTap: () => setState(() => _isImageShown = !_isImageShown),
                child: Center(
                  child: new CachedNetworkImage(
                    imageUrl: url,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  createPostHead() {
    return FutureBuilder(
      future: usersReference.document(ownerId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return LinearProgressIndicator();
        }
        User user = User.fromDocument(dataSnapshot.data);
        bool isPostOwner = currentUserOnlineId == ownerId;
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(user.url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isPostOwner
                  ? IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      onPressed: () => controlPostDelete(context),
                    )
                  : Text(""),
            ],
          ),
        );
      },
    );
  }

  controlPostDelete(BuildContext mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("What do you want to do?"),
            children: [
              SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Delete the Post",
                      style: GoogleFonts.montserrat(fontSize: 15),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                  removeUserPost();
                },
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.cancel),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Cancel",
                      style: GoogleFonts.montserrat(fontSize: 15),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  removeUserPost() async {
    postReference
        .document(ownerId)
        .collection("usersPosts")
        .document(postId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    storageReference.child("post_$postId.jpg").delete();

    QuerySnapshot commentsQuerySnapshot = await commentsReference
        .document(postId)
        .collection("comments")
        .getDocuments();

    commentsQuerySnapshot.documents.forEach((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    AllPostsReference.document(postId).get().then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
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
        "timestamp": DateTime.now(),
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
      padding:
          const EdgeInsets.only(left: 25.0, top: 12, right: 25, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "$type".toUpperCase(),
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
            ),
          ),
          ReadMoreText(
            description,
            trimLines: 6,
            colorClickableText: Colors.grey,
            trimMode: TrimMode.Line,
            trimCollapsedText: ' ...read more',
            trimExpandedText: ' ..less',
            style: TextStyle(
              color: Colors.grey[800],
              height: 1.5,
              letterSpacing: .7,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  UpvoteButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 15),
      child: Row(
        children: [
          FlatButton.icon(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => displayComments(
              context,
              postId: postId,
              ownerId: ownerId,
              description: description,
              type: type,
            ),
            icon: Icon(
              //Ionicons.md_chatboxes,
              Octicons.comment_discussion,
              color: Colors.red,
            ),
            label: Text("Comment"),
          ),
        ],
      ),
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
