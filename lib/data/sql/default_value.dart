import 'package:libx/data/sql/constraint.dart';

class DefaultValue implements IConstraint {
  final dynamic _value;

  DefaultValue(this._value);

  dynamic getDefaultValue() => _value;
}
