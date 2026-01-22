import 'package:libx/data/sql/column.dart';

class Table implements ITable {
  final String _name;
  final List<Column> _columns = [];

  Table(this._name);

  Column column(String name) {
    Column column = Column(name);
    _columns.add(column);
    return column;
  }

  @override
  String getName() => _name;

  @override
  List<Column> getColumns() => _columns;
}

abstract class ITable {
  String getName();

  List<Column> getColumns();
}
