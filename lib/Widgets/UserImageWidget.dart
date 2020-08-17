import 'package:flutter/material.dart';
import 'package:westblockapp/Widgets/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserPhoto extends StatelessWidget {
  const UserPhoto({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of(context).auth.getCurrentUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.yellow,
              child: CircleAvatar(
                radius: 12,
                backgroundImage: user.photoUrl == null
                    ? CachedNetworkImageProvider(
                        "https://upload.wikimedia.org/wikipedia/en/a/ac/West_Block_Blues_logo_transparent.png")
                    : CachedNetworkImageProvider("${user.photoUrl}"),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
