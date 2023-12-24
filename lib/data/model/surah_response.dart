class ChapterResponse {
  final List<Chapter> chapters;

  ChapterResponse({required this.chapters});

  factory ChapterResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> chapterList = json['chapter'];
    final List<Chapter> chapters = chapterList
        .map((chapterJson) => Chapter.fromJson(chapterJson))
        .toList();

    return ChapterResponse(chapters: chapters);
  }
}

class Chapter {
  final int chapter;
  final int verse;
  final String text;

  Chapter({required this.chapter, required this.verse, required this.text});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapter: json['chapter'],
      verse: json['verse'],
      text: json['text'],
    );
  }
}
