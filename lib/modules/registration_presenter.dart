import 'package:hack19/data/registration_data.dart';

import '../dependency_injection.dart';

abstract class RegistrationViewContract {
  void onLoadRegistrationComplete(RegistrationData items);
  void onLoadRegistrationError(String error);
}

class RegistrationPresenter {
  RegistrationViewContract _view;
  RegistrationRepository _repository;

  RegistrationPresenter(this._view) {
    _repository = new Injector().registrationRepository;
  }

  void loadRegistration(String u_name,String u_email,String u_pwd,String u_image) {
    _repository
        .fetchData(u_name,u_pwd,u_email,u_image)
        .then((c) => _view.onLoadRegistrationComplete(c))
        .catchError((onError) => _view.onLoadRegistrationError(onError.toString()));
  }
}