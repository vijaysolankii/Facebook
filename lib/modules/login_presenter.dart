import 'package:hack19/data/login_data.dart';

import '../dependency_injection.dart';

abstract class LoginViewContract {
  void onLoadLoginComplete(LoginData items);
  void onLoadLoginError(String error);
}

class LoginPresenter {
  LoginViewContract _view;
  LoginRepository _repository;

  LoginPresenter(this._view) {
    _repository = new Injector().loginRepository;
  }

  void loadLogin(String mobile,String password,String device_id,String firebase_token) {
    _repository
        .fetchLoginData(mobile,password,device_id,firebase_token)
        .then((c) => _view.onLoadLoginComplete(c))
        .catchError((onError) => _view.onLoadLoginError(onError.toString()));
  }
}