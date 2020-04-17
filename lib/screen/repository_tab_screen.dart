import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:github/model/repository.dart';
import 'package:github/screen/repository_code_screen.dart';
import 'package:github/screen/user_screen.dart';
import 'package:github/widget/text_icon.dart';

class RepositoryTabScreen extends StatelessWidget {
  final Repository repository;

  RepositoryTabScreen({Key key, @required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                forceElevated: innerBoxIsScrolled,
                snap: true,
                floating: true,
                titleSpacing: 0,
                title: Text("${repository.name}"),
                bottom: TabBar(
                  isScrollable: true,
                  tabs: <Widget>[
                    Container(
                      child: const TextIcon(title: "Código", icon: const Icon(Icons.code)),
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    Container(
                      child: const TextIcon(title: "Proprietário", icon: const Icon(Icons.person)),
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              RepositoryCodeScreen(repository: repository),
              UserScreen(url: repository.owner.url),
            ],
          ),
        ),
      ),
    );
  }
}
