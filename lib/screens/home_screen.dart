import 'package:flutter/material.dart';
import 'bible_reader_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sacred Start')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (_) => BibleReaderScreen(book: 'Genesis', chapter: 1))
            );
          },
          child: Text('Start Reading'),
        ),
      ),
    );
  }
}
