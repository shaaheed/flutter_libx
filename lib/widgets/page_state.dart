import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/model.dart';

abstract class PageState<TModel extends Model<TModel>,
    TWidget extends StatefulWidget> extends State<TWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TModel _model;
  bool _isUpdateMode = false;

  PageState(TModel model) {
    _model = model;
  }

  getFormState() => _formKey;

  bool isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  bool isUpdateMode() => _isUpdateMode;

  TModel get model => _model;

  void init(Object? arguments) {
    if (arguments != null) {
      _isUpdateMode = true;
      if (arguments is TModel) {
        _model = arguments.clone();
      }
    } else {
      _model.id = const Uuid().v4();
    }
  }
}
