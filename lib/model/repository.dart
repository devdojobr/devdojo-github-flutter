import 'package:github/model/user.dart';

class Repository {
  String name;
  String fullName;
  String description;
  String language;
  User owner;
  int stars;

  Repository.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.fullName = json['full_name'],
        this.description = json['description'],
        this.language = json['language'],
        this.stars = json['stargazers_count'],
        this.owner = json['owner'] != null ? User.fromJson(json['owner']) : null;
}
