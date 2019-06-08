import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hack19/data/user_list_data.dart';

import 'login.dart';
import 'modules/user_list_presenter.dart';
import 'user_profile_list.dart';
import 'utils/common.dart';
import 'utils/preference.dart';
import 'package:http/http.dart' as http;

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50.0, left: 20),
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(UserProfilePage.tag);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Profile",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.black38,
            ),
          ),
          GestureDetector(
            onTap: () {
              PreferenceManager().setPref(Common.USER_ID,"");
              PreferenceManager().setPref(Common.USER_NAME,"");
              PreferenceManager().setPref(Common.USER_EMAIL,"");
              PreferenceManager().setPref(Common.USER_IMAGE,"");

              Navigator.of(context).pushReplacementNamed(LoginPage.tag);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
