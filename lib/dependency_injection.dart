import 'package:hack19/prod/feed_list_data_prod.dart';
import 'package:hack19/prod/user_list_data_prod.dart';

import 'data/feed_list_data.dart';
import 'data/login_data.dart';
import 'data/registration_data.dart';
import 'data/user_list_data.dart';
import 'prod/login_data_prod.dart';
import 'prod/registration_data_prod.dart';

enum Flavor { MOCK, PROD }

//DI
class Injector {
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  LoginRepository get loginRepository {
    return new ProdLoginRepository();
  }
  RegistrationRepository get registrationRepository {
    return new ProdRegistrationRepository();
  }

  UserListRepository get userlistRepository {
    return new ProdUserListRepository();
  }
  FeedListRepository get feedlistRepository {
    return new ProdFeedListRepository();
  }
}
