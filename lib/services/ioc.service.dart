import 'package:get_it/get_it.dart';

class IocService {
  static final _ioc = GetIt.instance;

  static addSingleton<T extends Object>(T instance) {
    _ioc.registerSingleton(instance);
  }

  static T get<T extends Object>() {
    return _ioc.get<T>();
  }

  static setup() async {
    // addSingleton(DatabaseService());
  }
}
