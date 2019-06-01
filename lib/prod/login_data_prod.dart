import 'dart:convert';

import 'package:hack19/data/login_data.dart';
import 'package:hack19/utils/common.dart';
import 'package:hack19/utils/exception_class.dart';
import 'package:http/http.dart' as http;

class ProdLoginRepository implements LoginRepository {
  String loginUrl = "${Common.API}?ws_login";

  @override
  Future<LoginData> fetchLoginData(String email, String password,
      String device_id, String firebase_token) async {
    http.Response response = await http.post(
      // Encode URl
        Uri.encodeFull(loginUrl),
        // only accept json response
        headers: {
          "Accept": "Application/json"
        },
        body: {
          "u_email": email,
          "u_pwd": password,
          "imei_number": device_id,
          "device_token": firebase_token
        });
    final Map responseBody = json.decode(response.body);
    final statusCode = response.statusCode;
    print(responseBody);
    if (statusCode != 200 || responseBody == null) {
      throw new FetchDataException(
          "An error ocurred : [Status Code : $statusCode]");
    }
    return LoginData.fromMap(responseBody);
  }
}
