import 'package:universal_html/controller.dart';
import 'package:universal_html/html.dart';

import '../models/article_details_model.dart';
import '../util/constants.dart';

class ArticleParser {
  ArticleParser() {
    windowController = WindowController();
  }

  late WindowController windowController;

  Future<ArticleDetails> parseArticleBody(String articleId) async {
    String articleUrl = '$baseUrl/${articleId.replaceAll('_', '/')}';

    await windowController.openUri(Uri.parse(articleUrl));

    final articleDivElement = windowController.window?.document
        .querySelector('div[class^="article-module--article"');

    return _divtoArticleDetails(articleDivElement as DivElement);
  }

  ArticleDetails _divtoArticleDetails(DivElement articleDivElement) {
    HeadingElement titleHeadingElement =
        articleDivElement.children[0] as HeadingElement;
    DivElement bodyDivElement = articleDivElement.children[1] as DivElement;

    String title = titleHeadingElement.innerText;
    String body = bodyDivElement.innerHtml ?? '';

    return ArticleDetails(
      title: title,
      body: body,
    );
  }
}
