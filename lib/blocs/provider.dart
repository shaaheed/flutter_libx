import 'package:flutter/material.dart';
import './bloc.dart';

// 1
class BlocProvider<T extends Bloc> extends StatefulWidget {
  final Widget child;
  final T bloc;
  final bool disposeBloc;

  const BlocProvider({
    Key? key,
    required this.bloc,
    required this.child,
    this.disposeBloc = true,
  }) : super(key: key);

  // 2
  static T? of<T extends Bloc>(BuildContext? context) {
    // final type = _providerType<BlocProvider<T>>();
    if (context == null) return null;
    final BlocProvider<T>? provider =
        context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider?.bloc;
  }

  // 3
  // static Type _providerType<T>() => T;

  @override
  State createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  // 4
  @override
  Widget build(BuildContext context) => widget.child;

  // 5
  @override
  void dispose() {
    if (widget.disposeBloc) {
      widget.bloc.dispose();
    }
    super.dispose();
  }
}
