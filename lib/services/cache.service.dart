class CacheService {
  static final Map<String, dynamic> _cache = {};

  static add(String key, dynamic data) {
    _cache[key] = data;
  }

  static remove(String key) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    }
  }

  static Future<T?> get<T>(String key, [Future<T?> Function()? fn]) async {
    // if (_cache.containsKey(key)) {
    //   print("returning cached data");
    //   return _cache[key] as T;
    // }
    T? value = (await fn?.call()) as T;
    // ignore: avoid_print
    print("returning db data");
    if (value != null) {
      add(key, value);
    }
    return value;
  }
}
