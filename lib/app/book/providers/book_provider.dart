import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbn_scanner/app/book/providers/book_repository_provider.dart';
import 'package:isbn_scanner/domain/book/book.dart';

final bookProvider = FutureProvider.family<Book, String>((ref, isbn) {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBookByIsbn(isbn);
});
