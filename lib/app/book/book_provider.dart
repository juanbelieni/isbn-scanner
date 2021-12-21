import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbn_reader/domain/book/book.dart';
import 'package:isbn_reader/infra/book/book_repository.dart';

final bookRepositoryProvider = Provider((_) {
  return BookRepository();
});

final bookProvider = FutureProvider.family<Book, String>((ref, isbn) {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBookByIsbn(isbn);
});
