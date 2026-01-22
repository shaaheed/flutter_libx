import 'package:libx/data/sql/column.dart';
import 'package:libx/libx.dart';
import 'package:libx/data/where_clause.dart';
import 'package:sqflite/sqflite.dart';

abstract class SqfliteRepoService<T extends Model<T>> {
  SqfliteDbService getDatabase();

  String get table;

  T mapModel(Map<String, dynamic> map);

  List<T> mapModels(List<Map<String, dynamic>> result) {
    return List.generate(result.length, (i) {
      return mapModel(result[i]);
    });
  }

  String getSql() {
    return 'select * from $table';
  }

  WhereClause? buildWhere(String action, Object? arguments) => null;

  Future<List<T>?> list({
    int offset = 0,
    int limit = 10,
    Object? arguments,
  }) async {
    WhereClause? whereClause = buildWhere('list', arguments);
    String newSql =
        "${getSql()} ${whereClause?.toWhereString() ?? ''} limit $limit offset $offset";
    final result = await getDatabase().rawQuery(newSql, whereClause?.getArgs());
    return mapModels(result);
  }

  Future<T?> get(Object? arguments) async {
    WhereClause? whereClause = buildWhere('get', arguments);
    whereClause ??= WhereClause([]);
    whereClause.add('id', arguments);
    String newSql = "${getSql()} ${whereClause.toWhereString()} limit 1";
    final result = await getDatabase().rawQuery(newSql, whereClause.getArgs());
    return mapModel(result.first);
  }

  Future<int> insert(T model) {
    List<String> columns = [];
    List<dynamic> values = [];
    _fill(model.getTable().getColumns(), columns, values,
        (c) => c.getInsertable());
    String columnStr = columns.join(',');
    String valueStr = List.filled(columns.length, "?").join(",");
    String sql = 'insert into "$table" ($columnStr) values ($valueStr);';
    return getDatabase().rawInsert(sql, values);
  }

  Future<int> update(T model, WhereClause? where) {
    List<String> columns = [];
    List<dynamic> values = [];
    _fill(model.getTable().getColumns(), columns, values,
        (c) => c.getUpdatable());
    String whereStr = "where id=?";
    if (where != null) {
      whereStr = where.toWhereString();
      values.addAll(where.getArgs() as Iterable);
    }
    String columnStr = columns.join("=?, ");
    String sql = 'update "$table" set $columnStr $whereStr;';
    return getDatabase().rawUpdate(sql, values);
  }

  Future<int> delete(T model) {
    String sql = 'delete from "$table" where id=?;';
    return getDatabase().rawDelete(sql, [model.id]);
  }

  Future<int> deleteWhere(WhereClause where) {
    String sql = 'delete from "table ${where.toWhereString()}";';
    return getDatabase().rawDelete(sql, where.getArgs());
  }

  Future<int> count(WhereClause? where) async {
    List<dynamic> args = where?.getArgs() ?? [];
    String whereStr = where?.toWhereString() ?? "";
    String sql = 'select count(*) from "$table" $whereStr';
    final result = await getDatabase().rawQuery(sql, args);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  void _fill(List<Column> list, List<String> columns, List<dynamic> values,
      bool Function(Column c) fn) {
    for (final c in list) {
      if (fn(c)) {
        columns.add(c.getName());
        dynamic value = c.getValue();
        if (value is String) {
          value = '"$value"';
        }
        values.add(value);
      }
    }
  }
}
