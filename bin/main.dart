import 'package:universal_html/controller.dart';
import 'package:universal_html/html.dart';

import 'models/article_model.dart';
import 'models/article_section_model.dart';

void main(List<String> arguments) async {
  const roadmapUrl = 'https://refold.la/roadmap';
  final controller = WindowController();
  await controller.openUri(Uri.parse(roadmapUrl));

  final stagesDivElements = controller.window?.document
          .querySelectorAll('div[class^="stage-module--content"') ??
      [];

  //// Accessing Roadmap Info
  //
  //// Stages List
  //
  // for (DivElement divElement in stagesDivElements) {
  //   HeadingElement h4 = divElement.children[0] as HeadingElement;
  //   HeadingElement h2 = divElement.children[1] as HeadingElement;
  //   ParagraphElement p = divElement.children[2] as ParagraphElement;
  //   DivElement div = divElement.children[3] as DivElement;
  //   print(h4.innerText);
  //   print(h2.innerText);
  //   print(p.innerText);
  //   print('\n');
  // }

  // Accessing Stage Details
  DivElement firstStageDivElement = stagesDivElements[0];

  //div.stage-module--openedContent
  DivElement stageDetailsDivElement =
      firstStageDivElement.children[3] as DivElement;

  for (int i = 0; i < stageDetailsDivElement.children.length; i++) {
    if (i == 0) {
      //a (list to overview article)
      AnchorElement titleAnchorElement =
          stageDetailsDivElement.children[i] as AnchorElement;
      Article overviewArticle = anchorToOverview(titleAnchorElement, 'stage0');
      print(overviewArticle.id + " " + overviewArticle.title);

      // div (article section)
    } else {
      DivElement articleSectionDivElement =
          stageDetailsDivElement.children[i] as DivElement;
      ArticleSection articleSection =
          divToArticleSection(articleSectionDivElement, 'stage-0');

      print(articleSection.title);
      articleSection.articles.map(print);
    }
  }
}

// SECTION OVERVIEW
Article anchorToOverview(AnchorElement anchorElement, String sectionId) {
  String overviewId = sectionId + '-overview';
  String overviewTitle = '';

  DivElement childDiv = anchorElement.firstChild as DivElement;
  HeadingElement titleHeadingElement = childDiv.children[1] as HeadingElement;
  overviewTitle = titleHeadingElement.innerText;

  //TODO: call scraper on overview artcle (details)

  return Article(
    id: overviewId,
    title: overviewTitle,
  );
}

// Article SECTION
ArticleSection divToArticleSection(DivElement divElement, String stageId) {
  String sectionId = stageId;
  String sectionTitle = '';
  List<Article> articles = List<Article>.empty();

  HeadingElement titleHeadingElement = divElement.firstChild as HeadingElement;
  sectionId = sectionId + '-' + titleHeadingElement.innerText;

  for (Element anchorElement in divElement.children[1].children) {
    articles.add(anchorToArticle(anchorElement as AnchorElement, sectionId));
  }

  return ArticleSection(id: sectionId, title: sectionTitle, articles: articles);
}

// ARTICLE
Article anchorToArticle(AnchorElement anchorElement, String sectionId) {
  String articleId = sectionId;
  String articleTitle = '';

  DivElement childDiv = anchorElement.firstChild as DivElement;
  HeadingElement titleHeadingElement = childDiv.children[0] as HeadingElement;
  HeadingElement idHeadingElement = childDiv.children[1] as HeadingElement;

  articleId = articleId + "-" + idHeadingElement.innerText;
  articleTitle = titleHeadingElement.innerText;

  //TODO: call scraper on each article (details)

  return Article(
    id: articleId,
    title: articleTitle,
  );
}
