import 'package:flutter/widgets.dart';

class TextIcon extends StatelessWidget {
  final String title;
  final Icon icon;

  const TextIcon({Key key, this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: icon,
        ),
        Text(title),
      ],
    );
  }
}
