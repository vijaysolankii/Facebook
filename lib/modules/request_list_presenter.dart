import 'package:hack19/data/feed_list_data.dart';
import 'package:hack19/data/registration_data.dart';
import 'package:hack19/data/request_list_data.dart';
import 'package:hack19/data/user_list_data.dart';

import '../dependency_injection.dart';

abstract class RequestViewContract {
  void onLoadRequestListComplete(List<RequestListData> items);
  void onLoadRequestListError(String error);
}

class RequestListPresenter {
  RequestViewContract _view;
  RequestListRepository _repository;

  RequestListPresenter(this._view) {
    _repository = new Injector().requestlistRepository;
  }

  void loadUserData(String u_id) {
    _repository
        .fetchData(u_id)
        .then((c) => _view.onLoadRequestListComplete(c))
        .catchError((onError) => _view.onLoadRequestListError(onError.toString()));
  }
}