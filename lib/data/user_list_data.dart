class UserListData {
  String u_id;
  String u_name;
  String u_email;
  String u_image;
  String u_status;


  UserListData({this.u_id, this.u_name, this.u_email, this.u_image});

  UserListData.fromMap(Map<dynamic, dynamic> map)
      : u_id = map['u_id'],
        u_name = map['u_name'],
        u_email = map['u_email'],
        u_status = map['u_status'],
        u_image = map['u_image'];
}

abstract class UserListRepository {
  Future<List<UserListData>> fetchData(String u_id);
}
