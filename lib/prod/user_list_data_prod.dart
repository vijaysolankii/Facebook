import 'dart:convert';

import 'package:hack19/data/registration_data.dart';
import 'package:hack19/data/user_list_data.dart';
import 'package:hack19/utils/common.dart';
import 'package:hack19/utils/exception_class.dart';
import 'package:http/http.dart' as http;

class ProdUserListRepository implements UserListRepository {
  String registrationUrl = "${Common.API}?ws_user_list";

  @override
  Future<List<UserListData>> fetchData(String u_id) async {
    http.Response response = await http.post(
    // Encode URl
    Uri.encodeFull(registrationUrl),
    // only accept json response
    headers: {
    "Accept": "Application/json"
    },
    body: {
      "u_id": u_id
    });
    final Map responseBody = json.decode(response.body);
    final statusCode = response.statusCode;
    print(responseBody);
    if (statusCode != 200 || responseBody == null) {
    throw new FetchDataException(
    "An error ocurred : [Status Code : $statusCode]");
    }
    final List body = responseBody['user_list'];
    return body.map((c) => UserListData.fromMap(c)).toList();
  }
}
