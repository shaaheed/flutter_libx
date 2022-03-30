import 'package:libx/libx.dart';

abstract class RepositoryService<T extends Model<T>> {
  DatabaseService getDatabase();

  Future<List<T>?> list({
    int offset = 0,
    int limit = 10,
    Object? arguments,
  });

  Future<T?> get({Object? arguments});

  Future<int> insert(T model);

  Future<int> update(T model);

  Future<int> delete(T model);
}
