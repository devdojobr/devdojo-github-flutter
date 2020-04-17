import 'package:flutter/widgets.dart';

class WidgetCallSafe extends StatelessWidget {
  final bool Function() checkIfNull;
  final Widget Function() sucess;
  final Widget Function() fail;

  const WidgetCallSafe({@required this.checkIfNull, @required this.sucess, @required this.fail});

  @override
  Widget build(BuildContext context) {
    final bool isTrue = checkIfNull();
    if (isTrue) {
      return sucess();
    }
    return fail();
  }
}
