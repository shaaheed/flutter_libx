class Sql {
  static InsertSql insert(String table) {
    return InsertSql(table);
  }

  static UpdateSql update(String table) {
    return UpdateSql(table);
  }
}

class InsertSql extends InsertOrUpdateSql {
  InsertSql(String table) : super(table);

  @override
  String sql() {
    if (_keyValues.isNotEmpty) {
      return "insert into $table ($_columns) values($_values);";
    }
    return "";
  }

  @override
  List<Object> arguments() => _arguments;
}

class UpdateSql extends InsertOrUpdateSql {
  String? _whereKey;
  String? _whereValue;
  List<Object> _args = [];

  UpdateSql(String table) : super(table);

  UpdateSql where(String key, Object? value) {
    _whereKey = key;
    _whereValue = value!.toString();
    return this;
  }

  @override
  String sql() {
    if (_keyValues.isNotEmpty) {
      String _columns = _keyValues.keys.join("=?,");
      String _sql = "update $table ($_columns) values($_values)";
      if (_isValidWhere) {
        _args = _arguments;
        _args.add(_whereValue as Object);
        return "$_sql where $_whereKey=?;";
      }
      return "$_sql;";
    }
    return "";
  }

  @override
  List<Object> arguments() => _args.isNotEmpty ? _args : _arguments;

  bool get _isValidWhere =>
      _whereKey != null && _whereKey!.isNotEmpty && _whereValue != null;
}

// class DeleteSql extends SqlCommand {
//   DeleteSql(String table) : super(table);

//   @override
//   String sql() {
//     return 'delete from $table where id=?;';
//   }
// }

abstract class InsertOrUpdateSql extends SqlCommand {
  final Map<String, Object> _keyValues = {};

  InsertOrUpdateSql(String table) : super(table);

  InsertOrUpdateSql set(
    String key,
    Object value, {
    bool quote = true,
  }) {
    if (key.isNotEmpty) {
      _keyValues[key] = quote ? '$value' : value;
    }
    return this;
  }

  String get _columns => _keyValues.keys.join(",");

  String get _values => List.filled(_keyValues.keys.length, "?").join(",");

  List<Object> get _arguments => _keyValues.values.toList();
}

abstract class Where {
  late String _whereKey;
  late String? _whereValue;

  Where where(String key, Object? value) {
    _whereKey = key;
    _whereValue = value!.toString();
    return this;
  }

  Where(String key) {
    _whereKey = key;
  }

  bool get isValidWhere => _whereKey.isNotEmpty && _whereValue != null;
}

abstract class SqlCommand {
  final String table;

  SqlCommand(this.table);

  List<Object> arguments();

  String sql();
}
