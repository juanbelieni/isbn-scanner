import 'package:flutter/material.dart';
import 'package:isbn_reader/app/book/book_details_screen.dart';
import 'package:isbn_reader/app/scanner/scanner_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  Widget _mockBookDetails() {
    return const BookDetailsScreen(isbn: '8525056006');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISBN reader',
      debugShowCheckedModeBanner: false,
      // home: ScannerScreen(),
      home: _mockBookDetails(),
    );
  }
}
