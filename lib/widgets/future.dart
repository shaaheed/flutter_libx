import 'package:flutter/material.dart';
import './widgets.dart';

class FutureWidget<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T? data)? builder;
  final Widget Function()? empty;

  const FutureWidget({
    required this.future,
    this.builder,
    this.empty,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      key: key,
      future: future,
      builder: (futureContext, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgress();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData ||
              snapshot.data == null ||
              ((snapshot.data is List) &&
                  (snapshot.data as dynamic).length <= 0)) {
            if (empty != null) {
              return empty!.call();
            } else {
              return const NoData();
            }
          } else if (snapshot.hasData && builder != null) {
            return builder!.call(snapshot.data);
          }
        }
        return const SizedBox();
      },
    );
  }
}
