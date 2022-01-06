import 'package:universal_html/controller.dart';
import 'package:universal_html/html.dart';

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

  AnchorElement titleAnchorElement =
      stageDetailsDivElement.children.first as AnchorElement;
  HeadingElement titleH3Element =
      titleAnchorElement.children.first.children[1] as HeadingElement;

  print(titleH3Element.innerText);

  List<Element> stageArticlesDivList = stageDetailsDivElement.children;
  getArticlesList(stageArticlesDivList);
}

void getArticlesList(List<Element> articleDivList) {
  for (Element articleDivElement in articleDivList) {
    HeadingElement articleListTitle =
        articleDivElement.children.first as HeadingElement;
  }
}
