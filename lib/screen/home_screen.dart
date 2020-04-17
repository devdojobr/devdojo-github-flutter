import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:github/delegate/github_search_delegate.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bem vindo ao GitHub"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: GithubSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: const Center(child: const Text("Buscar repositórios públicos")),
    );
  }
}
