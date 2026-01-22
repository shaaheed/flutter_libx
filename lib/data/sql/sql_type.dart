import 'package:libx/data/sql/constraint.dart';

class SqlType {
  late Constraint _constraint;
  late String _sqlType;

  SqlType() {
    _constraint = Constraint();
  }

  Constraint text() {
    _sqlType = "TEXT";
    return _constraint;
  }

  Constraint real() {
    _sqlType = "REAL";
    return _constraint;
  }

  Constraint integer() {
    _sqlType = "INTEGER";
    return _constraint;
  }

  String getSqlType() => _sqlType;

  Constraint getConstraint() => _constraint;
}
