class RegistrationData {
  String success;
  String message;


  RegistrationData.fromMap(Map<dynamic,dynamic> map)
      : success = map['success'],
        message = map['message'];
}

abstract class RegistrationRepository {
  Future<RegistrationData> fetchData(String u_name,String u_pwd, String u_email,String u_image);
}
