import 'package:flutter/material.dart';
import '../models/verse_model.dart';
import '../models/book_model.dart';
import '../services/bible_api_service.dart';

class BibleReaderScreen extends StatefulWidget {
  final String book;
  final int chapter;

  BibleReaderScreen({required this.book, required this.chapter});

  @override
  _BibleReaderScreenState createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  late Future<List<Verse>> verses;
  late Future<List<Book>> books = BibleApiService.fetchBooks();
  bool isDarkMode = true; // Default to dark mode like in screenshot
  late String currentBook = widget.book;
  late int currentChapter = widget.chapter;
  String? selectedBookName;

  @override
  void initState() {
    super.initState();
    loadVerses();
  }
    void loadVerses() {
    verses = BibleApiService.fetchVerses(currentBook, currentChapter);
  }
  
  void goToNextChapter() {
    setState(() {
      currentChapter++;
      loadVerses();
    });
  }
  
  void goToPreviousChapter() {
    if (currentChapter > 1) {
      setState(() {
        currentChapter--;
        loadVerses();
      });
    }
  }
  
  void showChaptersDialog() {
    showModalBottomSheet(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Select Chapter",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 50, // Placeholder - you should determine max chapters dynamically
                  itemBuilder: (context, index) {
                    final chapterNum = index + 1;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentChapter = chapterNum;
                          loadVerses();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: chapterNum == currentChapter
                              ? Theme.of(context).primaryColor
                              : isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "$chapterNum",
                            style: TextStyle(
                              color: chapterNum == currentChapter
                                  ? Colors.white
                                  : isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showBookAndChapterSelector() {
    // Track selected book for chapter display
    String selectedBook = currentBook;
    int maxChapters = 50; // Default value, can be updated based on selected book
    
    showModalBottomSheet(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 500,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Select Book and Chapter",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        // Book Selector
                        Expanded(
                          child: FutureBuilder<List<Book>>(
                            future: books,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final bookList = snapshot.data!;
                                return ListView.builder(
                                  itemCount: bookList.length,
                                  itemBuilder: (context, index) {
                                    final book = bookList[index];
                                    final isSelected = selectedBook == book.book;
                                    return ListTile(
                                      title: Text(
                                        book.bookName,
                                        style: TextStyle(
                                          color: isDarkMode ? Colors.white : Colors.black,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                      tileColor: isSelected
                                          ? (isDarkMode ? Colors.grey[800] : Colors.grey[300]) 
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          selectedBook = book.book;
                                          // You could make an API call here to get the actual max chapters
                                          // For now we'll use the default or implement a lookup
                                          switch(book.book) {
                                            case 'Genesis': maxChapters = 50; break;
                                            case 'Exodus': maxChapters = 40; break;
                                            case 'Leviticus': maxChapters = 27; break;
                                            case 'Numbers': maxChapters = 36; break;
                                            case 'Deuteronomy': maxChapters = 34; break;
                                            default: maxChapters = 25; break; // Default for other books
                                          }
                                        });
                                      },
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Failed to load books'));
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            }
                          ),
                        ),
                        // Chapter Selector
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.all(16.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: maxChapters,
                            itemBuilder: (context, index) {
                              final chapterNum = index + 1;
                              final isSelected = selectedBook == currentBook && chapterNum == currentChapter;
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  // Update global state when selecting a chapter
                                  this.setState(() {
                                    currentBook = selectedBook;
                                    currentChapter = chapterNum;
                                    loadVerses();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$chapterNum",
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : isDarkMode ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button
              IconButton(
                icon: Icon(
                  Icons.navigate_before,
                  size: 30,
                  color: currentChapter > 1 
                      ? (isDarkMode ? Colors.white : Colors.black) 
                      : Colors.grey,
                ),
                onPressed: currentChapter > 1 ? goToPreviousChapter : null,
              ),
              
              // Audio player
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Play/pause audio logic
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      child: Icon(
                        Icons.play_arrow,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: showBookAndChapterSelector,
                    child: Text(
                      "$currentBook $currentChapter",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Next button
              IconButton(
                icon: Icon(
                  Icons.navigate_next,
                  size: 30,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: goToNextChapter,
              ),
            ],
          ),
        ),
        body: FutureBuilder<List<Verse>>(
          future: verses,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final verseList = snapshot.data!;
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  // Hide the book title section on scroll
                  if (scrollNotification is ScrollUpdateNotification) {
                    setState(() {});
                  }
                  return true;
                },
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: verseList.length,
                  itemBuilder: (context, index) {
                    final v = verseList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${v.verseNumber}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.grey : Colors.grey[700],
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              v.verseText,
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                color: isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load verses'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
