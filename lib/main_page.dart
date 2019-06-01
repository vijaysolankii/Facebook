import 'package:flutter/material.dart';
import 'package:hack19/chats.dart';
import 'package:hack19/home.dart';
import 'package:hack19/user_list.dart';

class SocialHome extends StatefulWidget {
  static String tag = 'ana-sayfa';
  @override
  _SocialHomeState createState() => _SocialHomeState();
}

class _SocialHomeState extends State<SocialHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            new HomePage(),
            new UserListPage(),
            new UserListPage(),
            // new Container(color: Colors.green),
            // new Container(color: Colors.blue),
          ],
        ),
        bottomNavigationBar: new TabBar(
          indicatorWeight: 1.0,
          tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.supervised_user_circle)),
            Tab(icon: Icon(Icons.settings)),
            // Tab(icon: Icon(Icons.people)),
            // Tab(icon: Icon(Icons.settings)),
          ],
          labelColor: Color(0xFF5791FB),
          unselectedLabelColor: Colors.black38,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Color(0xFF5791FB),
        ),
      ),
    );
  }
}
