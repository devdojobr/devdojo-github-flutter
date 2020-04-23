import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:github/model/content.dart';
import 'package:github/service/github_service.dart';
import 'package:github/widget/async_layout_constructor.dart';
import 'package:github/widget/widget_call_safe.dart';

class RepositoryContentBlobScreen extends StatelessWidget {
  final Base64Codec base64Codec = Base64Codec();
  final Utf8Codec utf8codec = Utf8Codec();
  final Content content;

  RepositoryContentBlobScreen({Key key, @required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              titleSpacing: 0,
              title: Text(content.name ?? content.path),
            ),
          ];
        },
        body: AsyncLayoutConstructor<Content>.future(
          future: GithubService.findFileByUrl(content.url),
          hasDataWidget: (data) {
            final String decodeContent = tryDecode(data);
            return WidgetCallSafe(
              checkIfNull: () => decodeContent != null,
              sucess: () {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: HighlightView(
                      decodeContent,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      theme: githubTheme,
                      language: 'javascript',
                    ),
                  ),
                );
              },
              fail: () {
                return const Center(
                  child: const Text("Não foi possível ler o arquivo"),
                );
              },
            );
          },
          hasErrorWidget: (err) => const Center(child: const Text("Ocorreu um erro, verifique sua conexão e tente novamente")),
          loadingWidget: () => const Center(child: const CircularProgressIndicator()),
          hasDataEmptyWidget: () => Container(),
        ),
      ),
    );
  }

  String tryDecode(Content content) {
    try {
      return utf8codec.decode(base64Codec.decode(content.content.replaceAll("\n", "")));
    } catch (err) {
      return null;
    }
  }
}
