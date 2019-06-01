import 'data/login_data.dart';
import 'prod/login_data_prod.dart';

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

}
