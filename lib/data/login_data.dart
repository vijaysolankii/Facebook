class LoginData {
  String u_id;
  String u_name;
  String u_email;
  String u_image;


  LoginData.fromMap(Map<dynamic,dynamic> map)
      : u_id = map['data']['u_id'],
        u_name = map['data']['u_name'],
        u_email = map['data']['u_email'],
        u_image = map['data']['u_image'];
}

abstract class LoginRepository {
  Future<LoginData> fetchLoginData(String mobile,String password, String device_id,String firebase_token);
}
