import 'package:flutter/material.dart';
import '/services/services.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/add_edit_appbar.dart';
import '../../widgets/app_scaffold.dart';
import '../../models/model.dart';
import '../../object_factory.dart';
import '../../widgets/circular_progress.dart';
import 'page.mixin.dart';
import 'stateful.page.dart';
import '../app_button.dart';
import '../../utils.dart';

abstract class FormPage<T extends Model<T>> extends StatefulPage
    with PageMixin {
  final ObjectFactory<_FormPageState<T>> state =
      ObjectFactory(() => _FormPageState<T>());

  FormPage({
    Object? arguments,
    Key? key,
  }) : super(key: key);

  T createModel();

  Future<void> onSubmit();

  T get model => state.getCurrent()._model;

  bool get isUpdateMode => state.getCurrent()._isUpdateMode;

  bool get isLoading => state.getCurrent()._loading;

  GlobalKey<FormState> get formState => state.getCurrent()._formState;

  void handleSubmit() => state.getCurrent().handleSubmit();

  String getSubmitButtonText(BuildContext context) => 'Submit'.i18n(context);

  void initState() {}

  void setState(VoidCallback fn) => state.getCurrent()._setState(fn);

  @override
  AppBar getAppBar(BuildContext context) {
    return AddEditAppBar(
      context: context,
      title: getTitle(context),
      formState: formState,
      onSave: handleSubmit,
    );
  }

  @override
  Widget getScaffold(BuildContext context) {
    return AppScaffold(
      appBar: getAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (isLoading) const CircularProgress(),
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 35.0,
                      left: 10,
                      right: 20.0,
                    ),
                    child: Form(
                      key: formState,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
  final _formState = GlobalKey<FormState>();
  late T _model;
  bool _isUpdateMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.arguments != null) {
      _isUpdateMode = true;
      if (widget.arguments is T) {
        _model = (widget.arguments as T).clone();
      }
    } else {
      _model = widget.createModel();
      _model.id = const Uuid().v4();
    }
    widget.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.getScaffold(context);
  }

  void handleSubmit() async {
    if (_formState.currentState != null &&
        _formState.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      try {
        await widget.onSubmit();
        Navigator.pop(context, _model);
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
        _loading = false;
      });
    }
  }

  _setState(VoidCallback fn) {
    setState(fn);
  }
}
