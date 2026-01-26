class WhereClause {
  final String _sql;
  final List<dynamic>? _args;

  const WhereClause(this._sql, [this._args = const []]);

  WhereClause and(WhereClause other) =>
      WhereClause('($_sql AND ${other._sql})', [..._args!, ...other._args!]);

  WhereClause or(WhereClause other) =>
      WhereClause('($_sql OR ${other._sql})', [..._args!, ...other._args!]);

  WhereClause not() => WhereClause('(NOT $_sql)', _args);

  String get sql => 'WHERE $_sql';

  List<dynamic>? get args => _args;
}

class Where {
  static WhereColumn col(String name) => WhereColumn(name);
}

class WhereColumn {
  final String name;
  const WhereColumn(this.name);

  WhereClause eq(dynamic value) => WhereClause('$name = ?', [value]);

  WhereClause ne(dynamic value) => WhereClause('$name != ?', [value]);

  WhereClause gt(num value) => WhereClause('$name > ?', [value]);

  WhereClause gte(num value) => WhereClause('$name >= ?', [value]);

  WhereClause lt(num value) => WhereClause('$name < ?', [value]);

  WhereClause lte(num value) => WhereClause('$name <= ?', [value]);

  WhereClause like(String value) => WhereClause('$name LIKE ?', [value]);

  WhereClause isNull() => WhereClause('$name IS NULL');

  WhereClause isNotNull() => WhereClause('$name IS NOT NULL');

  WhereClause includes(List<dynamic> values) {
    final placeholders = List.filled(values.length, '?').join(', ');
    return WhereClause('$name IN ($placeholders)', values);
  }
}
