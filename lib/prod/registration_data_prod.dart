import 'dart:convert';

import 'package:hack19/data/registration_data.dart';
import 'package:hack19/utils/common.dart';
import 'package:hack19/utils/exception_class.dart';
import 'package:http/http.dart' as http;

class ProdRegistrationRepository implements RegistrationRepository {
  String registrationUrl = "${Common.API}?ws_registartion";

  @override
  Future<RegistrationData> fetchData(String u_name, String u_pwd, String u_email, String u_image) async {
    http.Response response = await http.post(
    // Encode URl
    Uri.encodeFull(registrationUrl),
    // only accept json response
    headers: {
    "Accept": "Application/json"
    },
    body: {
      "u_name": u_name,
      "u_pwd": u_pwd,
      "u_email": u_email,
      "u_image": u_image
    });
    final Map responseBody = json.decode(response.body);
    final statusCode = response.statusCode;
    print(responseBody);
    if (statusCode != 200 || responseBody == null) {
    throw new FetchDataException(
    "An error ocurred : [Status Code : $statusCode]");
    }
    return RegistrationData.fromMap(responseBody);
  }
}
