class StoryListData {
  String s_id;
  String u_name;
  String u_image;
  String u_id;
  String file;
  String title;
  String create_date;


  StoryListData.fromMap(Map<dynamic, dynamic> map)
      : s_id = map['s_id'],
        u_id = map['u_id'],
        u_name = map['u_name'],
        u_image = map['u_image'],
        title = map['title'],
        file = map['file'],
        create_date = map['create_date'];
}

abstract class StoryListRepository {
  Future<List<StoryListData>> fetchData(String u_id);
}
