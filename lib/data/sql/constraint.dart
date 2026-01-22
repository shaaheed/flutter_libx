import 'package:libx/data/sql/default_value.dart';
import 'package:libx/data/sql/not_null_constraint.dart';
import 'package:libx/data/sql/null_constraint.dart';
import 'package:libx/data/sql/unique_constraint.dart';

class Constraint implements IConstraint {
  late IConstraint _constraint;

  Constraint();

  NullConstraint isNull() {
    _constraint = NullConstraint();
    return _constraint as NullConstraint;
  }

  NotNullConstraint isNotNull() {
    _constraint = NotNullConstraint();
    return _constraint as NotNullConstraint;
  }

  UniqueConstraint isUnique() {
    _constraint = UniqueConstraint();
    return _constraint as UniqueConstraint;
  }

  void defaultValue(dynamic value) {
    _constraint = DefaultValue(value);
  }

  IConstraint getConstraint() => _constraint;
}

abstract class IConstraint {}
