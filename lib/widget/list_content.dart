import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:github/model/content.dart';
import 'package:github/screen/repository_content_blob_screen.dart';
import 'package:github/screen/repository_folder_screen.dart';

class ListContent extends StatelessWidget {
  final List<Content> contents;
  final Map<String, Widget> typeWidget = {
    "dir": const Icon(Icons.folder, color: Colors.blue),
    "file": const Icon(Icons.insert_drive_file, color: Colors.grey),
  };

  ListContent({Key key, @required this.contents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Content> files = contents.where((f) => f.type != "dir").toList();
    final List<Content> folders = contents.where((f) => f.type == "dir").toList();
    folders.addAll(files);

    return ListView.builder(
      itemCount: folders.length,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      itemBuilder: (build, index) {
        final Content content = folders[index];
        final Widget icon = typeWidget[content.type];
        return ListTile(
          onTap: callback(context, content),
          leading: icon,
          title: Text(content.name),
        );
      },
    );
  }

  Function callback(BuildContext context, Content content) {
    final Map<String, Function> typeCallback = {
      "dir": () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RepositoryFolderScreen(content: content),
          ),
        );
      },
      "file": () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RepositoryContentBlobScreen(content: content),
          ),
        );
      },
    };
    return typeCallback[content.type];
  }
}
