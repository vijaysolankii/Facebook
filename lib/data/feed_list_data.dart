class FeedListData {
  String p_id;
  String u_name;
  String u_image;
  String u_id;
  String like_count;
  String title;
  String description;
  String file;
  String share_count;
  String create_date;
  String update_date;


  FeedListData.fromMap(Map<dynamic, dynamic> map)
      : p_id = map['p_id'],
        u_id = map['u_id'],
        u_name = map['u_name'],
        u_image = map['u_image'],
        like_count = map['like_count'],
        title = map['title'],
        description = map['description'],
        file = map['file'],
        share_count = map['share_count'],
        create_date = map['create_date'],
        update_date = map['update_date'];
}

abstract class FeedListRepository {
  Future<List<FeedListData>> fetchData(String u_id);
}
