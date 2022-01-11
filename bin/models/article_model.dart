class Article {
  Article({
    required this.id,
    required this.title,
    required this.body,
  });

  String id;
  String title;
  String body;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  factory Article.empty() => Article(id: '', title: '', body: '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
      };

  @override
  String toString() {
    return 'id: $id, title: $title,\n$body';
  }
}
