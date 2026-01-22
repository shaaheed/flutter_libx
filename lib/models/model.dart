
import 'package:libx/services/data/sql_column.dart';

abstract class Model<TModel> extends GenericModel<String, TModel> {
  Model(String id) : super(id);
}

abstract class GenericModel<TKey, TModel> extends Object {
  TKey id;

  GenericModel(this.id);

  TModel clone();

  List<SqlColumn> toSqlColumn();
}
