import 'package:flutter/material.dart';
import '../../models/model.dart';
import '/object_factory.dart';

abstract class AbstractTabView<T, TModel extends Model<TModel>> {
  ObjectFactory<State<StatefulWidget>>? get state;
  T get model;
  int get index;

  BuildContext? get context;

  Widget build(BuildContext context, Widget? widget);

  void onTabChanged(int index);

  void refresh({Object? arguments});

  void reset();

  void initState();

  void dispose();
}
