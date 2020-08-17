import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:westblockapp/Home/homepage.dart';
import 'package:westblockapp/Services/auth_service.dart';
import 'package:westblockapp/Views/SignUp.dart';
import 'package:westblockapp/Widgets/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowMaterialGrid: false,
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeController(),
          '/signUp': (BuildContext context) =>
              SignUp(authFormType: AuthFormType.signUp),
        },
        //home: HomeController(),
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChange,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool _signedIn = snapshot.hasData;
          return _signedIn
              ? MyHomePage()
              : SignUp(
                  authFormType: AuthFormType.signUp,
                );
        }
        return Container();
      },
    );
  }
}
