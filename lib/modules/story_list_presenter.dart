import 'package:hack19/data/feed_list_data.dart';
import 'package:hack19/data/registration_data.dart';
import 'package:hack19/data/story_list_data.dart';
import 'package:hack19/data/user_list_data.dart';

import '../dependency_injection.dart';

abstract class StoryViewContract {
  void onLoadStoryListComplete(List<StoryListData> items);
  void onLoadStoryListError(String error);
}

class StoryListPresenter {
  StoryViewContract _view;
  StoryListRepository _repository;

  StoryListPresenter(this._view) {
    _repository = new Injector().storylistRepository;
  }

  void loadUserData(String u_id) {
    _repository
        .fetchData(u_id)
        .then((c) => _view.onLoadStoryListComplete(c))
        .catchError((onError) => _view.onLoadStoryListError(onError.toString()));
  }
}