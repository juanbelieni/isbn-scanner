import 'package:flutter/material.dart';
import 'package:isbn_reader/app/book/book_details_screen.dart';
import 'package:isbn_reader/app/home/home_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  Widget _mockBookDetails() {
    // Admirável mundo novo: 8525056006
    // Darwin sem frescura: 8595084696
    return const BookDetailsScreen(isbn: '-1');
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ISBN reader',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      // home: _mockBookDetails(),
    );
  }
}
