class Article {
  Article({
    required this.id,
    required this.thumbTitle,
    required this.title,
    required this.body,
  });

  String id;
  String thumbTitle;
  String title;
  String body;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        thumbTitle: json["thumbTitle"],
        title: json["title"],
        body: json["body"],
      );

  factory Article.empty() => Article(id: '', thumbTitle: '', title: '', body: '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "thumbTitle": thumbTitle,
        "title": title,
        "body": body,
      };

  @override
  String toString() {
    return 'id: $id,\n thumbTitle: $thumbTitle, : $title,\n$body';
  }
}
