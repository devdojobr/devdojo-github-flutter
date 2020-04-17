import 'package:flutter/widgets.dart';

class Pagination<T> {
  final int total;
  final List<T> items;

  const Pagination({@required this.total, @required this.items});
}
