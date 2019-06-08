import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hack19/data/user_list_data.dart';

import 'login.dart';
import 'main_page.dart';
import 'modules/user_list_presenter.dart';
import 'utils/common.dart';
import 'utils/preference.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hack19/data/registration_data.dart';
import 'package:hack19/login.dart';
import 'package:hack19/main_page.dart';

import 'modules/registration_presenter.dart';
import 'package:http_parser/http_parser.dart';

class UserProfilePage extends StatefulWidget {
  static String tag = 'profile-page';

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  RegistrationPresenter _presenter;

  String _name, _email;
  TextEditingController nameController, emailController;
  String id, image;

  @override
  void initState() {
    super.initState();
    _name = "Ravi Patel";
    getData();
  }

  Future getData() async {
    print("getEventData");
    id = await PreferenceManager().getPref(Common.USER_ID);
    _name = await PreferenceManager().getPref(Common.USER_NAME);
    _email = await PreferenceManager().getPref(Common.USER_EMAIL);
    image = await PreferenceManager().getPref(Common.USER_IMAGE);
    setState(() {
      nameController = new TextEditingController(text: _name);
      emailController = new TextEditingController(text: _email);
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50.0, left: 20),
              child: Text(
                'User profile',
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
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      _pickingType = FileType.ANY;
                      _openFileExplorer();
                    },
                    child: Container(
                      child: CircleAvatar(
                        maxRadius: 70,
                        backgroundImage: NetworkImage(Common.IMAGE_PATH+image),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                          validator: (str) =>
                              str.isEmpty ? 'Insert name' : null,
                          onSaved: (str) => _name = str,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(60.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xFFFFFFFF),
                            contentPadding: EdgeInsets.all(20.0),
                            hintText: 'Enter Your Name',
                            hintStyle: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16.0,
                              fontFamily: 'Josefin',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: emailController,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                          validator: (str) =>
                              !str.contains('@') ? 'Invalid E-Mail' : null,
                          onSaved: (str) => _email = str,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(60.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xFFFFFFFF),
                            contentPadding: EdgeInsets.all(20.0),
                            hintText: 'serdar.plt21@gmail.com',
                            hintStyle: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16.0,
                              fontFamily: 'Josefin',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.blueAccent,
                              padding:
                                  EdgeInsets.fromLTRB(46.0, 16.0, 46.0, 16.0),
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Josefin',
                                  fontSize: 22.0,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                var form = _formKey.currentState;

                                if (form.validate()) {
                                  form.save();
                                  updateProfile();
                                } else {
                                  print("error");
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FileType _pickingType;
  String _fileName = '';
  String _path = '';
  bool _hasValidMime = false;

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        _path = await FilePicker.getFilePath(type: _pickingType);
      } on Exception catch (e) {
        print("Unsupported operation" + e.toString());
      }

      if (!mounted) return;
      setState(() {
        _fileName = _path != null ? _path.split('/').last : '...';
      });
    }
  }

  Future updateProfile() async {
    Map<String, String> map = {"Accept": "Application/json"};
    Uri uri = Uri.parse('${Common.API}?ws_user_update');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers.addAll(map);
    request.fields['u_id'] = id;
    request.fields['u_name'] = nameController.text;
    request.fields['u_email'] = emailController.text;
    if (_path != "") {
      request.files.add(await http.MultipartFile.fromPath('file', _path,
          contentType: new MediaType('application', 'x-tar')));
    }
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        setState(() {
          print(value);
          var convertDataToJson = json.decode(value);
          var success = convertDataToJson['success'];
          print(success);
          // ignore: unused_local_variable
          var message = convertDataToJson['message'];
          var img = (convertDataToJson['u_image']);
          if (success) {
            if (img != null && img != "") {
              PreferenceManager().setPref(Common.USER_IMAGE, convertDataToJson['u_image']);
            }
            PreferenceManager().setPref(Common.USER_NAME, nameController.text);
            PreferenceManager().setPref(Common.USER_EMAIL, emailController.text);
            Navigator.pop(context);
          } else {
            final snackBar = SnackBar(content: Text(message));
            Scaffold.of(context).showSnackBar(snackBar);
          }
        });
      });
    }
  }
}
