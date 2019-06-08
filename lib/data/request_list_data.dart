class RequestListData {
  String u_id;
  String u_name;
  String u_image;
  String u_email;

  RequestListData.fromMap(Map<dynamic, dynamic> map)
      : u_email = map['u_email'],
        u_id = map['u_id'],
        u_name = map['u_name'],
        u_image = map['u_image'];
}

abstract class RequestListRepository {
  Future<List<RequestListData>> fetchData(String u_id);
}
