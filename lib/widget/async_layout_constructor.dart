import 'package:flutter/widgets.dart';

class AsyncLayoutConstructor<T> extends StatefulWidget {
  final Future<T> future;
  final Widget Function(T data) hasDataWidget;
  final Widget Function() hasDataEmptyWidget;
  final Widget Function(Object err) hasErrorWidget;
  final Widget Function() loadingWidget;

  const AsyncLayoutConstructor.future({
    Key key,
    @required this.future,
    @required this.hasDataWidget,
    this.hasDataEmptyWidget,
    @required this.hasErrorWidget,
    @required this.loadingWidget,
  }) : super(key: key);

  @override
  _AsyncLayoutConstructorState<T> createState() => _AsyncLayoutConstructorState<T>();
}

class _AsyncLayoutConstructorState<T> extends State<AsyncLayoutConstructor<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (widget.hasDataEmptyWidget != null && isEmptyList(snapshot.data)) {
            return widget.hasDataEmptyWidget();
          }
          return widget.hasDataWidget(snapshot.data);
        }
        if (snapshot.hasError) {
          return widget.hasErrorWidget(snapshot.error);
        }
        return widget.loadingWidget();
      },
    );
  }

  bool isEmptyList(dynamic arg) {
    if (arg is List<dynamic> || arg is Map || arg is String) {
      return arg.isEmpty;
    }
    return false;
  }
}
