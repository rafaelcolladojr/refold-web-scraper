class ArticleDetails {
  ArticleDetails({
    required this.title,
    required this.body,
  });

  String title;
  String body; // Body of the article in HTML format

  factory ArticleDetails.empty() => ArticleDetails(
        title: '',
        body: '',
      );
}
