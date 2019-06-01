import 'package:flutter/material.dart';
import 'package:hack19/login.dart';
import 'package:hack19/main_page.dart';

void main() => runApp(SocialApp());

class SocialApp extends StatelessWidget {
  final pages = <String, WidgetBuilder> {
    LoginPage.tag: (context) => LoginPage(),
    SocialHome.tag: (context) => SocialHome(),
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
      home: LoginPage(),
      routes: pages,
    );
  }
}

