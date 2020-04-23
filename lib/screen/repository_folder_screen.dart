import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:github/model/content.dart';
import 'package:github/service/github_service.dart';
import 'package:github/widget/async_layout_constructor.dart';
import 'package:github/widget/list_content.dart';

class RepositoryFolderScreen extends StatelessWidget {
  final Content content;

  const RepositoryFolderScreen({Key key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(content.name),
      ),
      body: AsyncLayoutConstructor<List<Content>>.future(
        future: GithubService.findFolderByUrl(content.url),
        hasDataWidget: (data) => ListContent(contents: data),
        hasErrorWidget: (err) => const Center(child: const Text("Ocorreu um erro, verifique sua conexão e tente novamente")),
        loadingWidget: () => const Center(child: const CircularProgressIndicator()),
        hasDataEmptyWidget: () => Container(),
      ),
    );
  }
}
