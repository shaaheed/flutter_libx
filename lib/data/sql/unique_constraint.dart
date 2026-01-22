import 'package:libx/data/sql/constraint.dart';
import 'package:libx/data/sql/default_value.dart';

class UniqueConstraint implements IConstraint {
  late IConstraint _constraint;

  UniqueConstraint();

  void defaultValue(dynamic value) {
    _constraint = DefaultValue(value);
  }

  IConstraint getConstraint() => _constraint;
}
