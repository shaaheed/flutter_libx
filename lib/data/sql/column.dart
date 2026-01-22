import 'package:libx/data/sql/sql_type.dart';
import 'package:libx/data/sql/foreign_key.dart';

class Column {
  final String _name;
  late dynamic Function() _value;

  late SqlType _sqlType;
  late ForeignKey _foreignKey;
  late bool _insertable = false;
  late bool _updatable = false;

  Column(this._name);

  Column value(dynamic Function() _value) {
    this._value = _value;
    return this;
  }

  Column insertable() {
    _insertable = true;
    return this;
  }

  Column updatable() {
    _updatable = true;
    return this;
  }

  SqlType type() {
    _sqlType = SqlType();
    return _sqlType;
  }

  ForeignKey foreignKey(String table) {
    _foreignKey = ForeignKey(this, table);
    return _foreignKey;
  }

  String getName() => _name;

  SqlType getSqlType() => _sqlType;

  ForeignKey getForeignKey() => _foreignKey;

  bool getInsertable() => _insertable;

  bool getUpdatable() => _updatable;

  dynamic getValue() => _value();
}
