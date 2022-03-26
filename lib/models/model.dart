import 'package:flutter/foundation.dart';

abstract class Model<TModel> extends GenericModel<String, TModel> {
  @mustCallSuper
  Model(String id) : super(id);
}

abstract class GenericModel<TKey, TModel> extends Object {
  TKey id;

  GenericModel(this.id);

  TModel clone();
}
