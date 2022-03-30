class Table {
  final String name;
  final List<ColumnData> _columns = [];

  Table(this.name);

  Column column(String name) {
    var data = ColumnData();
    data.columnName = name;
    var column = Column(data);
    _columns.add(data);
    return column;
  }

  test() {
    var test = Table('test');
    test.column('a').type().real().isNull().setDefault('o');
  }
}

class ColumnData {
  String? columnName;
  Column? column;
  String? type;
  ColumnType? columnType;
  String? isNull;
  String? isNotNull;
  String? isUnique;
  String? defaultValue;
  ColumnOption? option;
  String? foreignKey;
  String? foreignKeyReferenceTableName;
  String? foreignKeyReferenceTableColumnName;
}

class Column {
  final ColumnData _data;

  Column(this._data) {
    _data.column = this;
  }

  ColumnType type() {
    var type = ColumnType(_data);
    return type;
  }

  ForeignKeyConstraint foreignKey(String key) {
    _data.foreignKey = key;
    return ForeignKeyConstraint(_data);
  }
}

class ForeignKeyConstraint {
  final ColumnData _data;
  ForeignKeyConstraint(this._data);

  ForeignKeyConstraintTable table(String table) {
    _data.foreignKeyReferenceTableName = table;

    return ForeignKeyConstraintTable(_data);
  }
}

class ForeignKeyConstraintTable {
  final ColumnData _data;
  ForeignKeyConstraintTable(this._data);

  Column columns(String columns) {
    _data.foreignKeyReferenceTableColumnName = columns;
    return _data.column as Column;
  }
}

class ColumnType {
  final ColumnData _data;
  late ColumnOption _option;

  ColumnType(this._data) {
    _data.type = "TEXT";
    _option = ColumnOption(_data);
  }

  ColumnOption text() {
    _data.type = "TEXT";
    return _option;
  }

  ColumnOption real() {
    _data.type = "REAL";
    return _option;
  }

  ColumnOption integer() {
    _data.type = "INTEGER";
    return _option;
  }
}

class ColumnOption {
  final ColumnData _data;

  ColumnOption(this._data);

  ColumnOption isNull() {
    _data.isNull = "NULL";
    return this;
  }

  void isNotNull() {
    _data.isNotNull = "NOT NULL";
  }

  void isUnique() {
    _data.isUnique = "UNIQUE";
  }

  void setDefault(String value) {
    _data.defaultValue = value;
  }
}
