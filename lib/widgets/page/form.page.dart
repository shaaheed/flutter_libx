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

  T createModel();

  Future<void>? onSubmit() => null;

  T? get model => state.getCurrent()._model;

  bool get isUpdateMode => state.getCurrent()._isUpdateMode;

  bool get isLoading => state.getCurrent()._loading;

  bool get isSubmitting => state.getCurrent()._submitting;

  GlobalKey<FormState> get formState => state.getCurrent()._formState;

  void handleSubmit() => state.getCurrent().handleSubmit();

  String getSubmitButtonText(BuildContext context) => 'Submit'.i18n(context);

  Future<void>? initState() => null;

  void setState(VoidCallback fn) => state.getCurrent()._setState(fn);

  @override
  AppBar getAppBar(BuildContext context) {
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
                          padding: const EdgeInsets.only(
                            top: 35.0,
                            left: 10,
                            right: 20.0,
                          ),
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
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => state.createNew();
}

class _FormPageState<T extends Model<T>> extends State<FormPage<T>> {
  bool _loading = false;
  bool _submitting = false;
  final _formState = GlobalKey<FormState>();
  T? _model;
  bool _isUpdateMode = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    Future.delayed(Duration.zero, () {
      Object? _arguments;
      if (widget.arguments != null &&
          widget.arguments is NavigatorActionArguments<T>) {
        _arguments =
            (widget.arguments as NavigatorActionArguments<T>).arguments;
      } else {
        _arguments = widget.arguments;
      }
      if (_arguments != null) {
        _isUpdateMode = true;
        if (_arguments is T) {
          _model = _arguments.clone();
        }
      } else {
        _model = widget.createModel();
      }
      Future<void>? _initState = widget.initState();
      if (_initState != null) {
        _initState.then((value) {
          setState(() {
            _loading = false;
          });
        });
      } else {
        setState(() {
          _loading = false;
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
        await widget.onSubmit.call();
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
