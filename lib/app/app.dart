import 'package:flutter/material.dart';
import 'package:isbn_scanner/app/book/book_details_screen.dart';
import 'package:isbn_scanner/app/home/home_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  Widget _mockBookDetails() {
    // Admirável mundo novo: 8525056006
    // Darwin sem frescura: 8525056006
    return const BookDetailsScreen(isbn: '8535914846');
  }

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: 'ISBN Scanner',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      // home: _mockBookDetails(),
    );
  }
}
