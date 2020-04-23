import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:github/model/user.dart';
import 'package:github/service/github_service.dart';
import 'package:github/widget/async_layout_constructor.dart';
import 'package:github/widget/widget_call_safe.dart';

class UserScreen extends StatefulWidget {
  final String url;
  final List<Widget> Function(BuildContext context, bool innerBoxIsScrolled) headerSliverBuilder;

  const UserScreen({Key key, @required this.url, this.headerSliverBuilder}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with AutomaticKeepAliveClientMixin<UserScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: AsyncLayoutConstructor<User>.future(
        future: GithubService.findUserByUrl(widget.url),
        hasDataWidget: (data) {
          return NestedScrollView(
            headerSliverBuilder: widget.headerSliverBuilder ?? (context, innerBoxIsScrolled) => [],
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.network(data.avatarUrl),
                    title: Text("${data.name}"),
                    subtitle: Text("${data.login}"),
                  ),
                  WidgetCallSafe(
                    checkIfNull: () => data.email != null || data.bio != null,
                    sucess: () {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          WidgetCallSafe(
                            checkIfNull: () => data.email != null,
                            sucess: () {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Text("${data.email}"),
                              );
                            },
                            fail: () => Container(),
                          ),
                          WidgetCallSafe(
                            checkIfNull: () => data.bio != null,
                            sucess: () {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Text("${data.bio}"),
                              );
                            },
                            fail: () => Container(),
                          ),
                        ],
                      );
                    },
                    fail: () => Container(),
                  ),
                  WidgetCallSafe(
                    checkIfNull: () => data.company != null,
                    sucess: () {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.people),
                        title: Text("${data.company}"),
                      );
                    },
                    fail: () => Container(),
                  ),
                  WidgetCallSafe(
                    checkIfNull: () => data.location != null,
                    sucess: () {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.person_pin_circle),
                        title: Text("${data.location}"),
                      );
                    },
                    fail: () => Container(),
                  ),
                ],
              ),
            ),
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
