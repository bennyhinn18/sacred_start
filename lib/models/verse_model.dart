class Verse {
  final int verseNumber;
  final String verseText;
  final String bookName;
  final int chapter;

  Verse({
    required this.verseNumber,
    required this.verseText,
    required this.bookName,
    required this.chapter,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verseNumber: json['verse_number'],
      verseText: json['verse'],
      bookName: json['book_name'],
      chapter: json['chapter'],
    );
  }
}
