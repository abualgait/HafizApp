import 'dart:convert';

class ChapterResponse {
  String id = "";
  final List<Chapter> chapters;

  ChapterResponse({required this.chapters, required this.id});

  factory ChapterResponse.fromJson(
      Map<String, dynamic> jsonData, String surahId) {
    final String id = surahId;
    final List<dynamic> chapterList = jsonData['chapter'];
    final List<Chapter> chapters = chapterList
        .map((chapterJson) => Chapter.fromJson(chapterJson))
        .toList();

    return ChapterResponse(chapters: chapters, id: id);
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> chapterListJson =
        chapters.map((chapter) => chapter.toJson()).toList();

    return {'chapter': json.encode(chapterListJson), 'id': id};
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

  Map<String, dynamic> toJson() {
    return {"chapter": chapter, "verse": verse, "text": text};
  }
}
