
import 'package:libx/data/sql/table.dart';

abstract class Model<TModel> extends GenericModel<String, TModel> {
  Model(String id) : super(id);
}

abstract class GenericModel<TKey, TModel> extends Object {
  TKey id;

  GenericModel(this.id);

  TModel clone();

  ITable getTable();
}
