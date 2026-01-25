class WhereClause {
  final String sql;
  final List<dynamic>? args;

  const WhereClause(this.sql, [this.args = const []]);

  WhereClause and(WhereClause other) =>
      WhereClause('($sql AND ${other.sql})', [...args!, ...other.args!]);

  WhereClause or(WhereClause other) =>
      WhereClause('($sql OR ${other.sql})', [...args!, ...other.args!]);

  WhereClause not() => WhereClause('(NOT $sql)', args);
}

class WhereBuilder {
  static WhereColumn column(String name) =>
      WhereColumn(name);
}

class WhereColumn {
  final String name;
  const WhereColumn(this.name);

  WhereClause eq(Object? value) => WhereClause('$name = ?', [value]);

  WhereClause ne(Object? value) => WhereClause('$name != ?', [value]);

  WhereClause gt(num value) => WhereClause('$name > ?', [value]);

  WhereClause gte(num value) => WhereClause('$name >= ?', [value]);

  WhereClause lt(num value) => WhereClause('$name < ?', [value]);

  WhereClause lte(num value) => WhereClause('$name <= ?', [value]);

  WhereClause like(String value) => WhereClause('$name LIKE ?', [value]);

  WhereClause isNull() => WhereClause('$name IS NULL');

  WhereClause isNotNull() => WhereClause('$name IS NOT NULL');

  WhereClause includes(List<Object?> values) {
    final placeholders = List.filled(values.length, '?').join(', ');
    return WhereClause('$name IN ($placeholders)', values);
  }
}
