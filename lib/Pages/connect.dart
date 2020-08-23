import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Pages/ForumRoutes/afc.dart';
import 'package:westblockapp/Pages/ForumRoutes/allFeed.dart';
import 'package:westblockapp/Pages/ForumRoutes/fanart.dart';
import 'package:westblockapp/Pages/ForumRoutes/isl.dart';
import 'package:westblockapp/Pages/ForumRoutes/offtopic.dart';
import 'package:westblockapp/Pages/ForumRoutes/players.dart';
import 'package:westblockapp/Pages/ForumRoutes/preseason.dart';
import 'package:westblockapp/Pages/ForumRoutes/transfer.dart';
import 'package:westblockapp/Widgets/CardsWidget.dart';
import 'package:westblockapp/models/Users.dart';
import 'Profile.dart';

class Connectpage extends StatelessWidget {
  final String title;
  final User gCurrentUser;

  const Connectpage({Key key, this.gCurrentUser, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      ProfilePage(userProfileId: currentUser.id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CircleAvatar(
                backgroundColor: Colors.yellow,
                radius: 17,
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: CachedNetworkImageProvider(gCurrentUser.url),
                ),
              ),
            ),
          )
        ],
        title: Text(this.title),
        centerTitle: false,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              snap: false,
              backgroundColor: Colors.transparent,
              expandedHeight: 450,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: "https://pbs.twimg.com/media/Ef7UyvzUwAEp6Gm.jpg",
                ),
              ),
            ),
          ];
        },
        body: ListView(
          children: [
            feedHome(context),
          ],
        ),
      ),
    );
  }

  Column feedHome(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            top: 15,
            bottom: 10,
          ),
          child: Text(
            "Feed Home",
            style: TextStyle(
              color: Color(0xFF011589),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(
          height: 10,
          thickness: .5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => TransferForumpage(
                  gCurrentUser: currentUser,
                  title: "Transfer",
                ),
              ),
            );
          },
          child: Cards(
            image:
                "https://pbs.twimg.com/profile_images/1431292496/transfa_400x400.jpg",
            title: "Trending Transfer Related News 🔁",
            subtitle: "transfer",
          ),
        ),
        Divider(
          height: 10,
          thickness: .5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => OFTForumpage(
                  gCurrentUser: currentUser,
                  title: "Off Topic",
                ),
              ),
            );
          },
          child: Cards(
            image:
                "https://s01.sgp1.cdn.digitaloceanspaces.com/article/124042-mzwnyhneyn-1563441580.jpg",
            title: "Off topics discussion thread 🇮🇳⚽",
            subtitle: "off topic",
          ),
        ),
        Divider(
          height: 10,
          thickness: .5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AFCForumpage(
                  gCurrentUser: currentUser,
                  title: "AFC Cup",
                ),
              ),
            );
          },
          child: Cards(
            image:
                "https://www.the-afc.com/img/image/upload/t_l2/v1561949779/zfw18hzaxgltalrpmydx.jpg",
            title: "AFC Tournament discussion thread 🏆🌎",
            subtitle: "asia",
          ),
        ),
        Divider(
          height: 10,
          thickness: .5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ISLForumpage(
                  gCurrentUser: currentUser,
                  title: "Indian Super League",
                ),
              ),
            );
          },
          child: Cards(
            image:
                "https://staticg.sportskeeda.com/editor/2020/08/d1b2c-15975764416564-800.jpg",
            title: "Indian Super League thread 🏆",
            subtitle: "isl",
          ),
        ),
        Divider(
          height: 10,
          thickness: .5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => PlayersForumpage(
                  gCurrentUser: currentUser,
                  title: "Players Discussion",
                ),
              ),
            );
          },
          child: Cards(
            image:
                "https://thefangarage.com/upload/media/Screenshot-20200407160247-765x450.png",
            title: "Players Discussion thread",
            subtitle: "players",
          ),
        ),
        Divider(
          height: 10,
          thickness: .5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => PreseasonForumpage(
                  gCurrentUser: currentUser,
                  title: "Preseason",
                ),
              ),
            );
          },
          child: Cards(
            image:
                "https://c.ndtvimg.com/bhttpu7_bengaluru-fc-twitter_625x300_27_July_18.jpg?q=60&imwidth=555",
            title: "Preseason discussion thread ⏱",
            subtitle: "pre-season",
          ),
        ),
        Divider(
          height: 10,
          thickness: .5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => FanartForumpage(
                  gCurrentUser: currentUser,
                  title: "Fan Art",
                ),
              ),
            );
          },
          child: Cards(
            image:
                "https://www.bengalurufc.com/wp-content/uploads/2019/09/First-Team-Mugshot.jpg",
            title: "Fan Art thread 🎨",
            subtitle: "fans",
          ),
        ),
        Divider(
          height: 10,
          thickness: .5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AllFeedForumpage(
                  gCurrentUser: currentUser,
                  title: "All Feed",
                ),
              ),
            );
          },
          child: Cards(
            image:
                "https://e00-marca.uecdn.es/assets/multimedia/imagenes/2017/06/28/14986550559577.jpg",
            title: "All Topics Feed",
            subtitle: "General",
          ),
        ),
        Divider(
          height: 10,
          thickness: .5,
        ),
      ],
    );
  }
}
