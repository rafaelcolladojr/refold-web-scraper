import 'dart:io' as io;
import 'dart:convert';

import 'package:universal_html/controller.dart';
import 'package:universal_html/html.dart';

import '../models/article_details_model.dart';
import '../models/article_model.dart';
import '../models/article_section_model.dart';
import '../models/roadmap_model.dart';
import '../models/stage_details_model.dart';
import '../models/stage_model.dart';
import '../util/constants.dart';
import '../util/roadmap_language.dart';
import '../util/roadmap_type.dart';
import 'article_parser.dart';

class RoadmapParser {
  RoadmapParser() {
    windowController = WindowController();
    articleParser = ArticleParser();
  }

  late WindowController windowController;
  late ArticleParser articleParser;

  Future<Roadmap> parseRoadmap(RoadmapType type,
      [RoadmapLanguage language = RoadmapLanguage.en]) async {
    String roadmapUrl =
        '$baseUrl/${type == RoadmapType.detailed ? "roadmap" : "simplified"}';

    await windowController.openUri(Uri.parse(roadmapUrl));

    final stagesDivElements = windowController.window?.document
            .querySelectorAll('div[class^="stage-module--content"') ??
        [];

    Roadmap roadmap = await _divsToRoadmap(stagesDivElements, type, language);

    return roadmap;
  }

  Future<Roadmap> _divsToRoadmap(
    List<dynamic> stagesDivElements,
    RoadmapType roadmapType,
    RoadmapLanguage roadmapLanguage,
  ) async {
    // Accessing Roadmap Info
    String type = roadmapType.toShortString();
    String lang = roadmapLanguage.toShortString();

    // Stages List
    List<Stage> stages = <Stage>[];
    for (DivElement divElement in stagesDivElements) {
      Stage stage = await _divToStage(divElement, roadmapType.toShortString());
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
  Future<Stage> _divToStage(
    DivElement divElement,
    String roadmapId,
  ) async {
    // Stage Info
    String subtitle = divElement.children[0].innerText;
    String headline = divElement.children[1].innerText;
    String intro = divElement.children[2].innerText;
    DivElement stageDetailsDivElement = divElement.children[3] as DivElement;
    String stageId = roadmapId +
        '_stage-' +
        subtitle.split(' ')[1]; // ex. "Stage 0" return "0"

    // Stage Details
    StageDetails stageDetails =
        await _divToStageDetails(stageDetailsDivElement, stageId);

    return Stage(
      id: stageId,
      subtitle: subtitle,
      headline: headline,
      intro: intro,
      details: stageDetails,
    );
  }

  // STAGE DETAILS
  Future<StageDetails> _divToStageDetails(
    DivElement divElement,
    String stageId,
  ) async {
    Article? overviewArticle;
    List<ArticleSection> articleSections = <ArticleSection>[];
    for (int i = 0; i < divElement.children.length; i++) {
      // Overview Article
      if (i == 0) {
        AnchorElement titleAnchorElement =
            divElement.children[i] as AnchorElement;
        overviewArticle = await _anchorToOverview(titleAnchorElement, stageId);

        // Article Sections
      } else {
        DivElement articleSectionDivElement =
            divElement.children[i] as DivElement;
        articleSections.add(
          await _divToArticleSection(articleSectionDivElement, stageId),
        );
      }
    }

    return StageDetails(
      overview: overviewArticle ?? Article.empty(),
      articleSections: articleSections,
    );
  }

  // SECTION OVERVIEW
  Future<Article> _anchorToOverview(
    AnchorElement anchorElement,
    String stageId,
  ) async {
    String overviewId = stageId + '_overview';

    // Get overview body info from new page
    ArticleDetails articleDetails =
        await articleParser.parseArticleBody(overviewId);

    return Article(
      id: overviewId,
      title: articleDetails.title,
      body: articleDetails.body,
    );
  }

  // Article SECTION
  Future<ArticleSection> _divToArticleSection(
    DivElement divElement,
    String stageId,
  ) async {
    List<Article> articles = <Article>[];

    // Section Title
    HeadingElement titleHeadingElement =
        divElement.firstChild as HeadingElement;
    String sectionTitle = titleHeadingElement.innerText.substring(3);

    // Section Id (None)
    String sectionId = stageId;

    for (Element anchorElement in divElement.children[1].children) {
      articles.add(
          await _anchorToArticle(anchorElement as AnchorElement, sectionId));
    }

    return ArticleSection(
        id: sectionId, title: sectionTitle, articles: articles);
  }

  // ARTICLE
  Future<Article> _anchorToArticle(
    AnchorElement anchorElement,
    String sectionId,
  ) async {
    String articleId = anchorElement.href?.replaceAll('/', '_') ?? '';

    //Find third instance of underscore in id, keep beyond.
    int thirdUnderscoreIndex = articleId.indexOf(
        '_', articleId.indexOf('_', articleId.indexOf('_') + 1) + 1);
    articleId = articleId.substring(thirdUnderscoreIndex + 1);

    // Get overview body info from new page
    ArticleDetails articleDetails =
        await articleParser.parseArticleBody(articleId);

    return Article(
      id: articleId,
      title: articleDetails.title,
      body: articleDetails.body,
    );
  }
}
