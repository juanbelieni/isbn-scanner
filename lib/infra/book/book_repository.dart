import 'package:isbn_reader/domain/book/book.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';

class BookRepository implements IBookRepository {
  final _http = Dio(
    BaseOptions(baseUrl: 'https://www.goodreads.com'),
  );

  @override
  Future<Book> getBookByIsbn(String isbn) async {
    final response = await _http.get('/book/isbn/$isbn?format=json');
    final document = parse(response.data);

    final title = document.querySelector('h1#bookTitle')?.text.trim();

    final authors = document
        .querySelectorAll('#bookAuthors [itemprop="name"]')
        .map((e) => e.text)
        .toList();

    final rating = double.parse(
      document.querySelector('#bookMeta [itemprop="ratingValue"]')?.text ?? '0',
    );

    final description =
        document.querySelector('#description [style="display:none"]')?.text;

    final coverUrl = document.querySelector('#coverImage')?.attributes['src'];

    if (title == null ||
        authors.isEmpty ||
        description == null ||
        coverUrl == null) {
      throw Exception('Book not found');
    }

    return Book(
      isbn: isbn,
      title: title,
      authors: authors,
      rating: rating,
      description: description,
      coverUrl: coverUrl,
    );
  }
}
