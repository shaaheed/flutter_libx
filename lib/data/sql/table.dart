import 'package:libx/data/sql/column.dart';

class Table implements ITable {
  final String _name;
  final List<SqlColumn> _columns = [];

  Table(this._name);

  SqlColumn column(String name) {
    SqlColumn column = SqlColumn(name);
    _columns.add(column);
    return column;
  }

  @override
  String getName() => _name;

  @override
  List<SqlColumn> getColumns() => _columns;
}

abstract class ITable {
  String getName();

  List<SqlColumn> getColumns();
}
