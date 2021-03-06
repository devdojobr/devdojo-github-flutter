import 'dart:convert';

import 'package:github/http/http_provider.dart';
import 'package:github/model/content.dart';
import 'package:github/model/repository.dart';
import 'package:github/model/user.dart';
import 'package:github/util/api_path.dart';
import 'package:github/util/pagination.dart';

abstract class GithubService {
  static Future<Pagination<Repository>> findAllRepositoryByName(String name, int page) async {
    var response = await HttpProvider.get("$apiPath/search/repositories?q=$name&page=$page");
    var keyMap = json.decode(response.body);

    Iterable iterable = keyMap['items'];
    List<Repository> categorias = iterable.map((repository) => Repository.fromJson(repository)).toList();

    return Pagination<Repository>(total: keyMap['total_count'], items: categorias);
  }

  static Future<List<Content>> findAllContentsByFullName(String fullName) async {
    var response = await HttpProvider.get("$apiPath/repos/$fullName/contents");
    Iterable iterable = json.decode(response.body);
    return iterable.map((content) => Content.fromJson(content)).toList();
  }

  static Future<List<Content>> findFolderByUrl(String url) async {
    var response = await HttpProvider.get(url);
    Iterable iterable = json.decode(response.body);
    return iterable.map((content) => Content.fromJson(content)).toList();
  }

  static Future<Content> findFileByUrl(String url) async {
    var response = await HttpProvider.get(url);
    return Content.fromJson(json.decode(response.body));
  }

  static Future<User> findUserByUrl(String url) async {
    var response = await HttpProvider.get(url);
    return User.fromJson(json.decode(response.body));
  }
}
