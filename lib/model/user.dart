class User {
  String name;
  String login;
  String avatarUrl;
  String url;
  String bio;
  String company;
  String location;
  String email;

  User.fromJson(Map<String, dynamic> json)
      : this.login = json['login'],
        this.name = json['name'],
        this.url = json['url'],
        this.bio = json['bio'],
        this.company = json['company'],
        this.location = json['location'],
        this.email = json['email'],
        this.avatarUrl = json['avatar_url'];
}
