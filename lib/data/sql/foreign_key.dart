import 'package:libx/data/sql/column.dart';

class ForeignKey {
  final SqlColumn _column;
  final String _table;
  late String _ref;

  ForeignKey(this._column, this._table);

  SqlColumn ref(String ref) {
    _ref = ref;
    return _column;
  }

  String getRef() => _ref;

  String getTable() => _table;
}
