import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isbn_reader/domain/book/book.dart';

class BookRepository implements IBookRepository {
  final _http = Dio(
    BaseOptions(baseUrl: 'https://www.goodreads.com'),
  );

  @override
  Future<Book> getBookByIsbn(String isbn) async {
    final response = await _http.get('/book/isbn/$isbn');
    final document = parse(response.data);

    final title = document.querySelector('h1#bookTitle')?.text.trim();

    final authors = document
        .querySelectorAll('#bookAuthors .authorName__container')
        .where((element) => element.querySelector('.role') == null)
        .map((e) => e.querySelector('[itemprop=name]')!.text.trim())
        .toList();

    final rating = double.parse(
      document.querySelector('#bookMeta [itemprop="ratingValue"]')?.text ?? '0',
    );

    final description = document
        .querySelector('#description [style="display:none"]')
        ?.text
        .trim();

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

  @override
  Future<void> saveBook(IBook book) async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedBooks') ?? [];
    final isbns = savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .map((e) => e.isbn)
        .toList();

    if (!isbns.contains(book.isbn)) {
      final json = jsonEncode(book.toJson());
      savedBooks.add(json);
      preferences.setStringList('savedBooks', savedBooks);
    }
  }

  @override
  Future<void> removeBook(IBook book) async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedBooks') ?? [];
    final isbns = savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .map((e) => e.isbn)
        .toList();

    if (isbns.contains(book.isbn)) {
      final json = jsonEncode(book.toJson());
      savedBooks.remove(json);
      preferences.setStringList('savedBooks', savedBooks);
    }
  }

  @override
  Future<List<Book>> getSavedBooks() async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedBooks') ?? [];
    return savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .toList();
  }
}
