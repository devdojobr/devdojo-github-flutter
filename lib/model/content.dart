class Content {
  String name;
  String path;
  String url;
  String type;
  String content;
  String sha;

  Content.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.path = json['path'],
        this.url = json['url'],
        this.type = json['type'],
        this.content = json['content'],
        this.sha = json['sha'];
}
