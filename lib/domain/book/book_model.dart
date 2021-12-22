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

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      isbn: json['isbn'] as String,
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>).cast<String>(),
      rating: json['rating'] as double,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isbn': isbn,
      'title': title,
      'authors': authors,
      'rating': rating,
      'description': description,
      'coverUrl': coverUrl,
    };
  }

  @override
  String toString() {
    return 'Book(title: $title, authors: $authors, rating: $rating, description: ${description.substring(0, 10)}, coverUrl: $coverUrl)';
  }
}
