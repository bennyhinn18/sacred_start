class Book {
  final int bookId;
  final String book;
  final String bookName;
  final String abbreviation;
  final String testament;
  final String testamentName;

  Book({
    required this.bookId,
    required this.book,
    required this.bookName,
    required this.abbreviation,
    required this.testament,
    required this.testamentName,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'],
      book: json['book'],
      bookName: json['book_name'],
      abbreviation: json['abbreviation'],
      testament: json['testament'],
      testamentName: json['testament_name'],
    );
  }
}