import 'package:libx/libx.dart';
import 'package:libx/services/data/sql_column.dart';
import 'package:libx/services/data/where_clause.dart';
import 'package:sqflite/sqflite.dart';

abstract class RepositoryService<T extends Model<T>> {
  DatabaseService getDatabase();

  String getTable();

  T mapModel(Map<String, dynamic> map);

  List<T> mapModels(List<Map<String, dynamic>> result) {
    return List.generate(result.length, (i) {
      return mapModel(result[i]);
    });
  }

  String getSql(WhereClause? where, int? offset, int? limit) {
    String table = getTable();
    String whereStr = where?.toWhereString() ?? '';
    String limitOffset = '';
    if (limit != null) limitOffset += 'limit $limit';
    if (offset != null) limitOffset += ' offset $offset';
    return 'select * from $table $whereStr $limitOffset';
  }

  Future<List<T>?> list({
    int offset = 0,
    int limit = 10,
    Object? arguments,
  });

  Future<T?> get(Object? arguments);

  Future<int> insert(T model) {
    List<SqlColumn> sqlColumns = model.toSqlColumn();
    List<String> columns = [];
    List<dynamic> values = [];
    _fill(sqlColumns, columns, values, (c) => c.insert);
    String columnStr = columns.join(',');
    String valueStr = List.filled(columns.length, "?").join(",");
    String sql = 'insert into "${getTable()}" ($columnStr) values ($valueStr);';
    return getDatabase().rawInsert(sql, values);
  }

  Future<int> update(T model, WhereClause? where) {
    List<SqlColumn> sqlColumns = model.toSqlColumn();
    List<String> columns = [];
    List<dynamic> values = [];
    _fill(sqlColumns, columns, values, (c) => c.update);
    String whereStr = "where id=?";
    if (where != null) {
      whereStr = where.toWhereString();
      values.addAll(where.getArgs() as Iterable);
    }
    String columnStr = columns.join("=?, ");
    String sql = 'update "${getTable()}" set $columnStr $whereStr;';
    return getDatabase().rawUpdate(sql, values);
  }

  Future<int> delete(T model) {
    String sql = 'delete from "${getTable()}" where id=?;';
    return getDatabase().rawDelete(sql, [model.id]);
  }

  Future<int> deleteWhere(WhereClause where) {
    String sql = 'delete from "${getTable()} ${where.toWhereString()}";';
    return getDatabase().rawDelete(sql, where.getArgs());
  }

  Future<int> count(WhereClause? where) async {
    List<dynamic> args = where?.getArgs() ?? [];
    String whereStr = where?.toWhereString() ?? "";
    String sql = 'select count(*) from "${getTable()}" $whereStr';
    final result = await getDatabase().rawQuery(sql, args);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  void _fill(List<SqlColumn> sqlColumns, List<String> columns,
      List<dynamic> values, bool Function(SqlColumn c) fn) {
    for (final c in sqlColumns) {
      if (fn(c)) {
        columns.add(c.name);
        dynamic value = c.value();
        if (value is String) {
          value = '"$value"';
        }
        values.add(value);
      }
    }
  }
}
