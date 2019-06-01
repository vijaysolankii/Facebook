import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hack19/data/user_list_data.dart';

import 'modules/user_list_presenter.dart';
import 'utils/common.dart';
import 'utils/preference.dart';
import 'package:http/http.dart' as http;


class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage>  implements UserViewContract{

  UserListPresenter _presenter;
  bool _isLoading = true;
  List<UserListData> userList = List();
  List<UserListData> mainUserList = List();

  TextEditingController controller = new TextEditingController();
  String id;
  _UserListPageState() {

    _presenter = UserListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    getData();
    controller.addListener(() {
      userList.clear();
      if(controller.text != ""){
        for(UserListData model in mainUserList){
          if(model.u_name.toLowerCase().contains(controller.text.toLowerCase())){
            userList.add(model);
          }
        }
      } else{
        userList.addAll(mainUserList);
      }
      setState(() {

      });
      print(controller.text);
    });
  }
  Future getData() async {
    print("getEventData");
     id = await PreferenceManager().getPref(Common.USER_ID);
    _isLoading = true;
    _presenter.loadUserData(id);
  }

  @override
  Widget build(BuildContext context) {
    createTile(UserListData friend) => Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF565973), width: 1.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundImage:
                    NetworkImage(Common.IMAGE_PATH + friend.u_image),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            friend.u_name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        if(friend.u_status == "0"){
                          sendRequiest(friend.u_id);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(friend.u_status == "2"?"Friend":friend.u_status == "1"?"Requiest Send":"Add friend"),
                            ),
                            friend.u_status == "0"?
                            IconButton(
                              color: Colors.blueAccent,
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ):Container(),
                          ],
                        )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

    final liste = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: userList.map((book) => createTile(book)).toList(),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:50.0,left: 20),
            child: Text(
              'Users',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: 'Search your friends...',
                  hintStyle: TextStyle(
                    color: Colors.black38,
                  ),
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.pinkAccent
                  ),
                  border: InputBorder.none),
            ),
          ),
          Flexible(
            child: liste,
          ),
        ],
      ),
    );
  }

  Future sendRequiest(String reciever_id) async {
    var response = await http.post(
      // Encode URl
      Uri.encodeFull("${Common.API}?ws_friend_request"),
      // only accept json response
      headers: {
        "Accept": "Application/json"
      },
      body: {
        "send_id": id,
        "reciever_id": reciever_id
      },
    );
    print(response.body);
    setState(() {
      var convertDataToJson = json.decode(response.body);
      var success = convertDataToJson['success'];
      print(success);
      // ignore: unused_local_variable
      var message = convertDataToJson['message'];
      if (success) {
        _presenter.loadUserData(id);
      } else {
        final snackBar = SnackBar(content: Text(message));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void onLoadUserListComplete(List<UserListData> items) {
    print("onLoadUserListComplete"+items.toString());
    userList.clear();
    mainUserList.clear();
    userList.addAll(items);
    mainUserList.addAll(items);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoadUserListError(String error) {
    print("onLoadUserListError"+error);
  }
}

class OnlinePersonAction extends StatelessWidget {
  final String personImagePath;
  final Color actColor;
  const OnlinePersonAction({
    Key key,
    this.personImagePath,
    this.actColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            padding: const EdgeInsets.all(3.4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(
                width: 2.0,
                color: Colors.pinkAccent,
              ),
            ),
            child: Container(
              width: 54.0,
              height: 54.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                image: DecorationImage(
                  image: AssetImage(personImagePath),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          child: Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              color: actColor,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 1.0,
                color: const Color(0x00000000),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
