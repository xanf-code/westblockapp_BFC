import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:westblockapp/Services/auth_service.dart';
import 'package:westblockapp/Widgets/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text("Profile"),
        centerTitle: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: Provider.of(context).auth.getCurrentUser(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (snapshot.connectionState == ConnectionState.done) {
                return Text("${user.displayName}");
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          FlatButton(
            onPressed: () async {
              try {
                Provider.of(context).auth.signOut();
              } catch (e) {
                print(
                  e.toString(),
                );
              }
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Feather.log_out),
                SizedBox(
                  width: 10,
                ),
                Text("Log Out"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
