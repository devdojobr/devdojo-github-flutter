import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:github/model/content.dart';
import 'package:github/model/repository.dart';
import 'package:github/service/github_service.dart';
import 'package:github/widget/async_layout_constructor.dart';
import 'package:github/widget/list_content.dart';

class RepositoryCodeScreen extends StatefulWidget {
  final Repository repository;

  const RepositoryCodeScreen({Key key, @required this.repository}) : super(key: key);

  @override
  _RepositoryCodeScreenState createState() => _RepositoryCodeScreenState();
}

class _RepositoryCodeScreenState extends State<RepositoryCodeScreen> with AutomaticKeepAliveClientMixin<RepositoryCodeScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: AsyncLayoutConstructor<List<Content>>.future(
        future: GithubService.findAllContentsByFullName(widget.repository.fullName),
        hasDataWidget: (data) {
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [],
            body: ListContent(contents: data),
          );
        },
        hasErrorWidget: (err) => const Center(child: const Text("Ocorreu um erro, verifique sua conexão e tente novamente")),
        loadingWidget: () => const Center(child: const CircularProgressIndicator()),
        hasDataEmptyWidget: () => Container(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
