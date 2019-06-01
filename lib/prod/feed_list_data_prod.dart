import 'dart:convert';

import 'package:hack19/data/feed_list_data.dart';
import 'package:hack19/data/registration_data.dart';
import 'package:hack19/data/user_list_data.dart';
import 'package:hack19/utils/common.dart';
import 'package:hack19/utils/exception_class.dart';
import 'package:http/http.dart' as http;

class ProdFeedListRepository implements FeedListRepository {
  String url = "${Common.API}?ws_feed_list";

  @override
  Future<List<FeedListData>> fetchData(String u_id) async {
    http.Response response = await http.post(
    // Encode URl
    Uri.encodeFull(url),
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
    final List body = responseBody['post_list'];
    return body.map((c) => FeedListData.fromMap(c)).toList();
  }
}
