import 'package:flutter/material.dart';
import 'package:github/http/http_exception.dart';
import 'package:github/model/repository.dart';
import 'package:github/screen/repository_tab_screen.dart';
import 'package:github/service/github_service.dart';
import 'package:github/util/pagination.dart';
import 'package:github/widget/async_layout_constructor.dart';
import 'package:github/widget/text_icon.dart';

class GithubSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = "",
        ),
      ];
    }
    return [Container()];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return RepositoryList(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return ListTile(
      leading: const Icon(Icons.book),
      title: Text('Repositórios com "$query"'),
      onTap: () => showResults(context),
    );
  }

  @override
  String get searchFieldLabel => "Pesquisar";
}

class RepositoryList extends StatefulWidget {
  final String query;

  const RepositoryList({Key key, @required this.query}) : super(key: key);

  @override
  _RepositoryListState createState() => _RepositoryListState();
}

class _RepositoryListState extends State<RepositoryList> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final List<Widget> cache = [];
  Future<List<Widget>> future;
  final maxGitResult = 1000;
  int page = 1;

  @override
  void initState() {
    future = findAllRepositoryByName();
    super.initState();
  }

  Future<List<Widget>> findAllRepositoryByName() async {
    try {
      final Pagination<Repository> pagination = await GithubService.findAllRepositoryByName(widget.query, page);
      if (cache.isEmpty) {
        cache.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(child: const Text("Repositórios encontrados")),
                Text("${pagination.total}"),
              ],
            ),
          ),
        );
      }
      if (cache.last is LoadingList) {
        cache.removeLast();
      }
      cache.addAll(pagination.items.map((it) => RepositoryView(repository: it)));
      if (haveMore(pagination)) {
        cache.add(LoadingList());
      }
      page++;
      return cache;
    } on HttpException catch (err) {
      print(err.body);
      throw err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: AsyncLayoutConstructor<List<Widget>>.future(
        future: future,
        hasDataWidget: (List<Widget> data) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: data.length,
            addAutomaticKeepAlives: false,
            itemBuilder: (build, index) {
              if (data[index] is LoadingList) {
                future = findAllRepositoryByName().whenComplete(() => setState(() {}));
              }
              return data[index];
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
          );
        },
        hasErrorWidget: (err) => const Center(child: const Text("Ocorreu um erro, verifique sua conexão e tente novamente")),
        loadingWidget: () => const Center(child: const CircularProgressIndicator()),
        hasDataEmptyWidget: () => Container(),
      ),
    );
  }

  bool haveMore(Pagination<Repository> pagination) {
    int total = cache.where((it) => it is RepositoryView).length;
    if (total < pagination.total && total < maxGitResult) {
      return true;
    }
    return false;
  }
}

class RepositoryView extends StatelessWidget {
  final Repository repository;

  const RepositoryView({Key key, this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RepositoryTabScreen(
              repository: repository,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Image.network(repository.owner.avatarUrl, width: 32, height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(repository.owner.login),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
            title: Text(repository.name),
            subtitle: Text(repository?.description ?? "Sem descrição"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(child: Text(repository?.language ?? "Não definida")),
                TextIcon(
                  title: "${repository.stars}",
                  icon: const Icon(Icons.star, color: Colors.amberAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: const CircularProgressIndicator());
  }
}
