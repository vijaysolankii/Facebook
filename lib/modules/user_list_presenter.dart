import 'package:hack19/data/registration_data.dart';
import 'package:hack19/data/user_list_data.dart';

import '../dependency_injection.dart';

abstract class UserViewContract {
  void onLoadUserListComplete(List<UserListData> items);
  void onLoadUserListError(String error);
}

class UserListPresenter {
  UserViewContract _view;
  UserListRepository _repository;

  UserListPresenter(this._view) {
    _repository = new Injector().userlistRepository;
  }

  void loadUserData(String u_id) {
    _repository
        .fetchData(u_id)
        .then((c) => _view.onLoadUserListComplete(c))
        .catchError((onError) => _view.onLoadUserListError(onError.toString()));
  }
}