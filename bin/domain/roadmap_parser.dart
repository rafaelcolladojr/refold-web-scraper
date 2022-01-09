import 'dart:io' as io;
import 'dart:convert';

import 'package:universal_html/controller.dart';
import 'package:universal_html/html.dart';

import '../models/article_model.dart';
import '../models/article_section_model.dart';
import '../models/roadmap_model.dart';
import '../models/stage_details_model.dart';
import '../models/stage_model.dart';
import '../util/constants.dart';
import '../util/roadmap_language.dart';
import '../util/roadmap_type.dart';

class RoadmapParser {
  RoadmapParser() {
    windowController = WindowController();
  }

  late WindowController windowController;

  Future<Roadmap> parseRoadmap({
    RoadmapType type = RoadmapType.detailed,
    RoadmapLanguage language = RoadmapLanguage.en,
  }) async {
    String roadmapUrl =
        '$baseUrl/${type == RoadmapType.detailed ? "roadmap" : "simplified"}';

    await windowController.openUri(Uri.parse(roadmapUrl));

    final stagesDivElements = windowController.window?.document
            .querySelectorAll('div[class^="stage-module--content"') ??
        [];

    Roadmap roadmap = _divsToRoadmap(stagesDivElements, type, language);

    return roadmap;
  }

  Roadmap _divsToRoadmap(List<dynamic> stagesDivElements,
      RoadmapType roadmapType, RoadmapLanguage roadmapLanguage) {
    // Accessing Roadmap Info
    String type = roadmapType.toShortString();
    String lang = roadmapLanguage.toShortString();

    // Stages List
    List<Stage> stages = List.empty(growable: true);
    for (DivElement divElement in stagesDivElements) {
      Stage stage = _divToStage(divElement, 'detail-en');
      stages.add(stage);
      //print(stage);
    }

    return Roadmap(
      type: type,
      lang: lang,
      stages: stages,
    );
  }

  // STAGE
  Stage _divToStage(DivElement divElement, String roadmapId) {
    // Stage Info
    String subtitle = divElement.children[0].innerText;
    String headline = divElement.children[1].innerText;
    String intro = divElement.children[2].innerText;
    DivElement stageDetailsDivElement = divElement.children[3] as DivElement;
    String stageId = roadmapId +
        '-stage' +
        subtitle.split(' ')[1]; // ex. "Stage 0" return "0"

    // Stage Details
    StageDetails stageDetails =
        _divToStageDetails(stageDetailsDivElement, stageId);

    return Stage(
      id: stageId,
      subtitle: subtitle,
      headline: headline,
      intro: intro,
      details: stageDetails,
    );
  }

  // STAGE DETAILS
  StageDetails _divToStageDetails(DivElement divElement, String stageId) {
    Article? overviewArticle;
    List<ArticleSection> articleSections =
        List<ArticleSection>.empty(growable: true);
    for (int i = 0; i < divElement.children.length; i++) {
      // Overview Article
      if (i == 0) {
        AnchorElement titleAnchorElement =
            divElement.children[i] as AnchorElement;
        overviewArticle = _anchorToOverview(titleAnchorElement, stageId);

        // Article Sections
      } else {
        DivElement articleSectionDivElement =
            divElement.children[i] as DivElement;
        articleSections.add(
          _divToArticleSection(articleSectionDivElement, stageId),
        );
      }
    }

    return StageDetails(
      overview: overviewArticle ?? Article.empty(),
      articleSections: articleSections,
    );
  }

  // SECTION OVERVIEW
  Article _anchorToOverview(AnchorElement anchorElement, String stageId) {
    String overviewId = stageId + '-overview';
    String relativeUrl = anchorElement.href ?? '';

    DivElement childDiv = anchorElement.firstChild as DivElement;
    HeadingElement titleHeadingElement = childDiv.children[1] as HeadingElement;
    String overviewTitle = titleHeadingElement.innerText;

    //TODO: call scraper on overview artcle (details)

    return Article(
      id: overviewId,
      title: overviewTitle,
    );
  }

  // Article SECTION
  ArticleSection _divToArticleSection(DivElement divElement, String stageId) {
    List<Article> articles = List<Article>.empty(growable: true);

    // Section Title
    HeadingElement titleHeadingElement =
        divElement.firstChild as HeadingElement;
    String sectionTitle = titleHeadingElement.innerText.substring(3);

    // Section Id (None)
    String sectionId = stageId;

    for (Element anchorElement in divElement.children[1].children) {
      articles.add(_anchorToArticle(anchorElement as AnchorElement, sectionId));
    }

    return ArticleSection(
        id: sectionId, title: sectionTitle, articles: articles);
  }

  // ARTICLE
  Article _anchorToArticle(AnchorElement anchorElement, String sectionId) {
    String relativeUrl = anchorElement.href ?? '';

    DivElement childDiv = anchorElement.firstChild as DivElement;
    HeadingElement titleHeadingElement = childDiv.children[0] as HeadingElement;
    HeadingElement idHeadingElement = childDiv.children[1] as HeadingElement;

    // Article ID ()
    String articleId = sectionId + "-" + idHeadingElement.innerText;
    String articleTitle = titleHeadingElement.innerText;

    //TODO: call scraper on each article (details)

    return Article(
      id: articleId,
      title: articleTitle,
    );
  }
}
