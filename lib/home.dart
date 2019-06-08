import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hack19/data/story_list_data.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data/feed_list_data.dart';
import 'modules/feed_list_presenter.dart';
import 'modules/story_list_presenter.dart';
import 'utils/common.dart';
import 'utils/date_helper.dart';
import 'utils/preference.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    implements FeedViewContract, StoryViewContract {
  FeedListPresenter _feedPresenter;
  StoryListPresenter _storyPresenter;
  bool _isLoading = true;
  List<FeedListData> feedList = List();
  List<StoryListData> storyList = List();
  TextEditingController controller = TextEditingController();
  String id;
  String user_image = "";

  _HomePageState() {
    _feedPresenter = FeedListPresenter(this);
    _storyPresenter = StoryListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    getData();
    if (Platform.isAndroid) {
      requestPermission();
    }
  }

  getUser() async {
    Map<String, String> map = {"Accept": "Application/json"};
    Uri uri = Uri.parse('${Common.API}?ws_user_data');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers.addAll(map);
    request.fields['u_id'] = id;
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        setState(() {
          print(value);
          var convertDataToJson = json.decode(value);
          var success = convertDataToJson['success'];
          print(success);
          var message = convertDataToJson['message'];
          if (success) {
            controller.text = "";
            _feedPresenter.loadUserData(id);
          } else {
            final snackBar = SnackBar(content: Text(message));
            Scaffold.of(context).showSnackBar(snackBar);
          }
        });
      });
    }
  }

  requestPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  Future getData() async {
    print("getEventData");
    setState(() {});
    id = await PreferenceManager().getPref(Common.USER_ID);
    user_image = await PreferenceManager().getPref(Common.USER_IMAGE);
    _isLoading = true;
    getUser();
    _feedPresenter.loadUserData(id);
    _storyPresenter.loadUserData(id);
  }

  @override
  Widget build(BuildContext context) {
    createTile(FeedListData feed) => Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Card(
            color: Colors.white,
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(Common.IMAGE_PATH + feed.u_image),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  feed.u_name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              Text(
                                DateHelper.chnageFormate(
                                    "hh:mm a", feed.create_date),
                                style: TextStyle(
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ),
                        id == feed.u_id
                            ? IconButton(
                                icon: Icon(
                                  Icons.more_horiz,
                                  color: Colors.black,
                                ),
                                onPressed: () {},
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  feed.file != ""
                      ? Container(
                          width: double.maxFinite,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(Common.IMAGE_PATH + feed.file,
                                  scale: 11.0),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 6.0),
                  Text(
                    feed.title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF627C),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                ),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.white70,
                                  size: 14.0,
                                ),
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                '${feed.like_count} likes',
                                style: TextStyle(
                                  color: Color(0xFFFF627C),
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFF5994FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                ),
                                child: Icon(
                                  Icons.chat,
                                  color: Colors.white70,
                                  size: 14.0,
                                ),
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                '6 comments',
                                style: TextStyle(
                                  color: Color(0xFF5994FF),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    createStory(StoryListData feed) => PersonStatus(
          model: feed,
        );
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Home',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: storyList.map((book) => createStory(book)).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Card(
                color: Color(0xFFFFFFFF),
                elevation: 1.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(Common.IMAGE_PATH + user_image),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: controller,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Share something',
                                labelStyle: TextStyle(fontSize: 12.0),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _pickingType = FileType.ANY;
                                    _openFileExplorer();
                                  },
                                  child: InkWell(
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.photo_camera,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Text(
                                          'Photo',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /*InkWell(
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.people,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      Text(
                                        'Tag',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),*/
                                GestureDetector(
                                  onTap: () {
                                    postFeed();
                                  },
                                  child: InkWell(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Send',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.send,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 6.0),
              child: Text(
                'FEEDS',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 18.0,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: feedList.map((book) => createTile(book)).toList(),
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

  Future postFeed() async {
    Map<String, String> map = {"Accept": "Application/json"};
    Uri uri = Uri.parse('${Common.API}?ws_feedpost');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers.addAll(map);
    request.fields['u_id'] = id;
    request.fields['title'] = controller.text;
    request.fields['description'] = "";
    request.fields['like_count'] = "0";
    request.fields['share_count'] = "0";
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
          if (success) {
            controller.text = "";
            final snackBar = SnackBar(content: Text(message));
            Scaffold.of(context).showSnackBar(snackBar);
            _feedPresenter.loadUserData(id);
          } else {
            final snackBar = SnackBar(content: Text(message));
            Scaffold.of(context).showSnackBar(snackBar);
          }
        });
      });
    }
  }

  @override
  void onLoadFeedListComplete(List<FeedListData> items) {
    print("onLoadFeedListComplete" + items.toString());
    feedList.clear();
    setState(() {
      feedList.addAll(items);
    });
  }

  @override
  void onLoadFeedListError(String error) {
    print("onLoadFeedListComplete" + error);
  }

  @override
  void onLoadStoryListComplete(List<StoryListData> items) {
    print("onLoadStoryListComplete" + items.toString());
    storyList.clear();
    setState(() {
      storyList.addAll(items);
    });
  }

  @override
  void onLoadStoryListError(String error) {
    print("onLoadStoryListError" + error);
  }
}

class PersonStatus extends StatelessWidget {
  final StoryListData model;

  const PersonStatus({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.all(3.4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            width: 2.0,
            color: Colors.pink,
          ),
        ),
        child: Container(
          width: 54.0,
          height: 54.0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(Common.IMAGE_PATH + model.file),
          ),
        ), /*Container(
          width: 54.0,
          height: 54.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            image: DecorationImage(
              image: NetworkImage(Common.IMAGE_PATH+model.u_image),
            ),
          ),
        ),*/
      ),
    );
  }
}
