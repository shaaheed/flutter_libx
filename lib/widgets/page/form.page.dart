import 'package:flutter/material.dart';
import '/services/services.dart';
import '../../widgets/add_edit_appbar.dart';
import '../../widgets/app_scaffold.dart';
import '../../models/model.dart';
import '../../object_factory.dart';
import '../../widgets/circular_progress.dart';
import 'page.mixin.dart';
import 'stateful.page.dart';
import '../app_button.dart';
import '../../utils.dart';
import '../../widgets/list/list.widget.dart';

abstract class FormPage<T extends Model<T>> extends StatefulPage
    with PageMixin {
  final ObjectFactory<_FormPageState<T>> state =
      ObjectFactory(() => _FormPageState<T>());

  FormPage({
    Object? arguments,
    Key? key,
  }) : super(arguments: arguments, key: key);

  Future<T> createModel();

  Future<void>? onSubmit() => null;

  T? get model => state.getCurrent()?._model;

  bool get isUpdateMode {
    var _updateMode = state.getCurrent()?._isUpdateMode;
    return _updateMode != null && _updateMode;
  }

  bool get isLoading {
    var _stateLoading = state.getCurrent()?._stateLoading;
    var _modelLoading = state.getCurrent()?._modelLoading;
    return _stateLoading == null || _stateLoading || _modelLoading == null || _modelLoading;
  }

  bool get isSubmitting {
    var _submitting = state.getCurrent()?._submitting;
    return _submitting == null || _submitting;
  }

  GlobalKey<FormState>? get formState => state.getCurrent()?._formState;

  void handleSubmit() => state.getCurrent()?.handleSubmit();

  String getSubmitButtonText(BuildContext context) =>
      isUpdateMode ? 'Update'.i18n(context) : 'Save'.i18n(context);

  Future<void>? initState() => null;

  void setState(VoidCallback fn) => state.getCurrent()?._setState(fn);

  @override
  AppBar? getAppBar(BuildContext context) {
    return AddEditAppBar(
      context: context,
      title: getTitle(context),
      formState: formState,
      onSave: isLoading ? null : handleSubmit,
    );
  }

  @override
  Widget getScaffold(BuildContext context) {
    return AppScaffold(
      appBar: getAppBar(context),
      body: isLoading
          ? const CircularProgress()
          : Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      if (isSubmitting) const CircularProgress(),
                      SingleChildScrollView(
                        child: Container(
                          padding: getPagePadding(),
                          child: Form(
                            key: formState,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: buildWidget(context, null),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  getSubmitButtonText(context),
                  onTap: handleSubmit,
                ),
              ],
            ),
    );
  }

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      state.createNew() as State<StatefulWidget>;
}

class _FormPageState<T extends Model<T>> extends State<FormPage<T>> {
  bool _stateLoading = false;
  bool _modelLoading = false;
  bool _submitting = false;
  final _formState = GlobalKey<FormState>();
  T? _model;
  bool _isUpdateMode = false;

  @override
  void initState() {
    super.initState();
    _stateLoading = true;
    _modelLoading = true;
    Future.delayed(Duration.zero, () {
      Object? model;
      if (widget.arguments != null &&
          widget.arguments is NavigatorActionArguments<T>) {
        model = (widget.arguments as NavigatorActionArguments<T>).model;
      } else {
        model = widget.arguments;
      }
      if (model != null) {
        _isUpdateMode = true;
        if (model is T) _model = model.clone();
        setState(() {
          _modelLoading = false;
        });
      } else {
        widget.createModel().then((value) {
          _model = value;
          setState(() {
            _modelLoading = false;
          });
        });
      }
      Future<void>? _initState = widget.initState();
      if (_initState != null) {
        _initState.then((value) {
          setState(() {
            _stateLoading = false;
          });
        });
      } else {
        setState(() {
          _stateLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.getScaffold(context);
  }

  void handleSubmit() async {
    if (_formState.currentState != null &&
        _formState.currentState!.validate()) {
      setState(() {
        _submitting = true;
      });
      try {
        if (widget.arguments is NavigatorActionArguments<T>) {
          NavigatorActionArguments<T> navigatorArguments =
              widget.arguments as NavigatorActionArguments<T>;
          if (navigatorArguments.action != null) {
            bool result = await navigatorArguments.action!.call(_model);
            if (result) {
              Navigator.pop(context, _model);
            }
          }
        } else {
          await widget.onSubmit.call();
          Navigator.pop(context, _model);
        }
        setState(() {
          _submitting = false;
        });
      } catch (ex) {
        ToastService.show(
          'Something went wrong. Try again'.i18n(context),
          context,
          backgroundColor: Colors.white,
          textColor: Colors.black38,
          duration: 4,
        );
        // ignore: avoid_print
        print(ex);
      }
      setState(() {
        _submitting = false;
      });
    }
  }

  void _setState(VoidCallback fn) {
    setState(fn);
  }
}
