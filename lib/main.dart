import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack19/login.dart';
import 'package:hack19/main_page.dart';
import 'package:hack19/register.dart';

import 'user_profile_list.dart';
import 'utils/common.dart';
import 'utils/preference.dart';

void main() => runApp(SocialApp());

class SocialApp extends StatefulWidget {
  @override
  _SocialAppState createState() => _SocialAppState();
}

class _SocialAppState extends State<SocialApp> {
  final pages = <String, WidgetBuilder> {
    LoginPage.tag: (context) => LoginPage(),
    SocialHome.tag: (context) => SocialHome(),
    RegisterPage.tag: (context) => RegisterPage(),
    UserProfilePage.tag: (context) => UserProfilePage(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social',
      theme: ThemeData(
        fontFamily: 'Josefin',
        primarySwatch: Colors.indigo,
      ),
      home: SplashPage(),
      routes: pages,
    );
  }
}

class SplashPage extends StatefulWidget {

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    goNextPage();
  }

  goNextPage() async {
    String id = await PreferenceManager().getPref(Common.USER_ID);
    Timer(Duration(seconds: 5), () {
      print("id " + id);
    /*  Route route = MaterialPageRoute(
          builder: (context) => id == "" ? LoginPage() : SocialHome());
      Navigator.pushReplacement(context, route);*/
      String routs = id==""?LoginPage.tag:SocialHome.tag;
      Navigator.of(context).pushReplacementNamed(routs);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image(
                  image: AssetImage('images/icon.png'),
                  width: 120.0,
                  height: 120.0,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Powered  Managed by DevsNik",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}



