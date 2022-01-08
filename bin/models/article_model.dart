class Article {
  Article({
    required this.id,
    required this.title,
  });

  String id;
  String title;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
      );

  factory Article.empty() => Article(id: '', title: 'Empty');

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };

  @override
  String toString() {
    return 'id: $id, title: $title';
  }
}
