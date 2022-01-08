import 'package:universal_html/controller.dart';
import 'package:universal_html/html.dart';

import 'models/article_model.dart';
import 'models/article_section_model.dart';
import 'models/stage_details_model.dart';
import 'models/stage_model.dart';

void main(List<String> arguments) async {
  const roadmapUrl = 'https://refold.la/roadmap';
  final controller = WindowController();
  await controller.openUri(Uri.parse(roadmapUrl));

  final stagesDivElements = controller.window?.document
          .querySelectorAll('div[class^="stage-module--content"') ??
      [];

  // Accessing Roadmap Info

  // Stages List

  for (DivElement divElement in stagesDivElements) {
    Stage stage = divToStage(divElement, 'detail-en');
    print(stage);
  }
}

Stage divToStage(DivElement divElement, String roadmapId) {
  // Stage Info
  String subtitle = divElement.children[0].innerText;
  String headline = divElement.children[1].innerText;
  String intro = divElement.children[2].innerText;
  DivElement stageDetailsDivElement = divElement.children[3] as DivElement;
  String stageId =
      roadmapId + '-stage' + subtitle.split(' ')[1]; // ex. "Stage 0" return "0"

  // Stage Details
  StageDetails stageDetails =
      divToStageDetails(stageDetailsDivElement, stageId);

  return Stage(
    id: stageId,
    subtitle: subtitle,
    headline: headline,
    intro: intro,
    details: stageDetails,
  );
}

StageDetails divToStageDetails(DivElement divElement, String stageId) {
  Article? overviewArticle;
  List<ArticleSection> articleSections =
      List<ArticleSection>.empty(growable: true);
  for (int i = 0; i < divElement.children.length; i++) {
    // Overview Article
    if (i == 0) {
      AnchorElement titleAnchorElement =
          divElement.children[i] as AnchorElement;
      overviewArticle = anchorToOverview(titleAnchorElement, stageId);

      // Article Sections
    } else {
      DivElement articleSectionDivElement =
          divElement.children[i] as DivElement;
      articleSections.add(
        divToArticleSection(articleSectionDivElement, stageId),
      );
    }
  }
  return StageDetails(
    overview: overviewArticle ?? Article.empty(),
    articleSections: articleSections,
  );
}

// SECTION OVERVIEW
Article anchorToOverview(AnchorElement anchorElement, String stageId) {
  String overviewId = stageId + '-overview';
  String overviewTitle = '';
  String relativeUrl = anchorElement.href ?? '';

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
  List<Article> articles = List<Article>.empty(growable: true);

  HeadingElement titleHeadingElement = divElement.firstChild as HeadingElement;
  String sectionTitle = titleHeadingElement.innerText.substring(3);
  String sectionId = stageId;

  for (Element anchorElement in divElement.children[1].children) {
    articles.add(anchorToArticle(anchorElement as AnchorElement, sectionId));
  }

  return ArticleSection(id: sectionId, title: sectionTitle, articles: articles);
}

// ARTICLE
Article anchorToArticle(AnchorElement anchorElement, String sectionId) {
  String articleId = sectionId;
  String articleTitle = '';
  String relativeUrl = anchorElement.href ?? '';

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
