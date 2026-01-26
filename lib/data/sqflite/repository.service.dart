import 'package:libx/libx.dart';
import 'package:sqflite/sqflite.dart';

abstract class SqfliteRepoService<T extends Model<T>> {
  SqfliteDbService getDatabase();

  String get table;

  T mapModel(Map<String, dynamic> map);

  String get prefix => 'x';

  String getSql(Object? arguments) => 'select $prefix.* from $table $prefix';

  List<T> mapModels(List<Map<String, dynamic>> result) {
    return List.generate(result.length, (i) {
      return mapModel(result[i]);
    });
  }

  WhereClause? buildWhere(String action, Object? arguments) => null;

  Future<List<T>?> list({
    int offset = 0,
    int limit = 10,
    Object? arguments,
  }) async {
    WhereClause? whereClause = buildWhere('list', arguments);
    String newSql =
        "${getSql(arguments)} ${whereClause?.sql ?? ''} limit $limit offset $offset";
    final result = await getDatabase().rawQuery(newSql, whereClause?.args);
    return mapModels(result);
  }

  Future<T?> get(Object? arguments) async {
    WhereClause? whereClause;
    if (arguments is WhereClause) {
      whereClause = arguments;
    } else {
      whereClause = buildWhere('get', arguments);
    }
    whereClause ??= Where.col('id').eq(arguments);
    String newSql = "${getSql(arguments)} ${whereClause.sql} limit 1";
    final result = await getDatabase().rawQuery(newSql, whereClause.args);
    return mapModel(result.first);
  }

  Future<int> insert(T model) {
    List<dynamic> values = [];
    List<String> columns = [];
    prepareColumnsAndValues(model.getTable().getColumns(), columns, values,
        (c) => c.getInsertable());
    String columnStr = columns.join(',');
    String valueStr = List.filled(columns.length, "?").join(",");
    String sql = 'insert into "$table" ($columnStr) values ($valueStr);';
    return getDatabase().rawInsert(sql, values);
  }

  Future<int> update(T model, WhereClause? where) {
    List<String> columns = [];
    List<dynamic> values = [];
    prepareColumnsAndValues(model.getTable().getColumns(), columns, values,
        (c) => c.getUpdatable());
    String whereStr = "where id=?";
    if (where != null) {
      whereStr = where.sql;
      values.addAll(where.args as Iterable);
    } else {
      values.add(model.id);
    }
    String columnStr = '${columns.join("=?, ")}=?';
    String sql = 'update "$table" set $columnStr $whereStr;';
    return getDatabase().rawUpdate(sql, values);
  }

  Future<int> delete(T model) {
    String sql = 'delete from "$table $prefix" where "$prefix.id=?";';
    return getDatabase().rawDelete(sql, [model.id]);
  }

  Future<int> deleteWhere(WhereClause where) {
    String sql = 'delete from "$table $prefix ${where.sql}";';
    return getDatabase().rawDelete(sql, where.args);
  }

  Future<int> count(Object? arguments) async {
    WhereClause? where;
    if (arguments is WhereClause) {
      where = arguments;
    } else {
      where = buildWhere('count', arguments);
    }
    List<dynamic> args = where?.args ?? [];
    String whereStr = where?.sql ?? "";
    String sql = 'select count(*) from "$table $prefix" $whereStr';
    final result = await getDatabase().rawQuery(sql, args);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  void prepareColumnsAndValues(List<SqlColumn> list, List<String> columns,
      List<dynamic> values, bool Function(SqlColumn c) fn) {
    for (final c in list) {
      if (fn(c)) {
        columns.add(c.getName());
        dynamic value = c.getValue();
        if (value is bool) {
          value = value ? 1 : 0;
        } else if (value is DateTime) {
          value = value.millisecondsSinceEpoch;
        }
        values.add(value);
      }
    }
  }
}
