import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/verse_model.dart';
import '../models/book_model.dart';

class BibleApiService {
  static const String baseUrl = 'https://api.bible.berinaniesh.xyz';
  
  static Future<List<Verse>> fetchVerses(String book, int chapter) async {
    final url = Uri.parse(
      '$baseUrl/verses?translation=TOVBSI&book=$book&chapter=$chapter'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((v) => Verse.fromJson(v)).toList();
    } else {
      print('Failed to load verses with status code: ${response.statusCode}'); // Debugging statement
      throw Exception('Failed to load verses');
    }
  }
  
  static Future<List<Book>> fetchBooks() async {
    final url = Uri.parse('$baseUrl/TOVBSI/books');
    
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      
      return data.map((b) => Book.fromJson(b)).toList();
    } else {
      print('Failed to load books with status code: ${response.statusCode}');
      throw Exception('Failed to load books');
    }
  }
  
  static Future<int> fetchChapterCount(String bookId) async {
    final url = Uri.parse('$baseUrl/chaptercount/$bookId');
    
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['count'];
    } else {
      print('Failed to load chapter count with status code: ${response.statusCode}');
      // Default to 30 chapters if we can't get the actual count
      return 30;
    }
  }
}
