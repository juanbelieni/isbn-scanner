import 'book_types.dart';

class Book implements IBook {
  @override
  final String isbn;
  @override
  final String title;
  @override
  final List<String> authors;
  @override
  final double rating;
  @override
  final String description;
  @override
  final String coverUrl;

  const Book({
    required this.isbn,
    required this.title,
    required this.authors,
    required this.rating,
    required this.description,
    required this.coverUrl,
  });

  @override
  String toString() {
    return 'Book(title: $title, authors: $authors, rating: $rating, description: ${description.substring(0, 10)}, coverUrl: $coverUrl)';
  }
}
