import 'package:libx/data/sql/constraint.dart';
import 'package:libx/data/sql/default_value.dart';
import 'package:libx/data/sql/unique_constraint.dart';

class NotNullConstraint implements IConstraint {
  late IConstraint _constraint;

  NotNullConstraint();

  UniqueConstraint isUnique() {
    _constraint = UniqueConstraint();
    return _constraint as UniqueConstraint;
  }

  void defaultValue(dynamic value) {
    _constraint = DefaultValue(value);
  }

  IConstraint getConstraint() => _constraint;
}
