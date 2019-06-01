import 'package:hack19/data/feed_list_data.dart';
import 'package:hack19/data/registration_data.dart';
import 'package:hack19/data/user_list_data.dart';

import '../dependency_injection.dart';

abstract class FeedViewContract {
  void onLoadFeedListComplete(List<FeedListData> items);
  void onLoadFeedListError(String error);
}

class FeedListPresenter {
  FeedViewContract _view;
  FeedListRepository _repository;

  FeedListPresenter(this._view) {
    _repository = new Injector().feedlistRepository;
  }

  void loadUserData(String u_id) {
    _repository
        .fetchData(u_id)
        .then((c) => _view.onLoadFeedListComplete(c))
        .catchError((onError) => _view.onLoadFeedListError(onError.toString()));
  }
}