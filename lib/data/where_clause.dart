class WhereClause {
  List<dynamic>? _args = [];
  final List<String> _properties = [];

  WhereClause(this._args);

  WhereClause add(String property, Object? value) {
    _args ??= [];
    if (value == null || property.isEmpty) return this;
    if (value is String && value.isEmpty) return this;
    _args!.add(value);
    _properties.add("$property=?");
    return this;
  }

  String toWhereString() {
    if (_properties.isNotEmpty) {
      return " where ${_properties.join(" and ")}";
    }
    return "";
  }

  List<dynamic>? getArgs() {
    return _args;
  }
}
