import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbn_scanner/app/book/providers/book_repository_provider.dart';
import 'package:isbn_scanner/app/shared/providers/saved_books_provider.dart';
import 'package:isbn_scanner/domain/book/book.dart';

final bookProvider = FutureProvider.family<IBook, String>((ref, isbn) {
  final repository = ref.watch(bookRepositoryProvider);
  final asyncBook = repository.getBookByIsbn(isbn);

  return asyncBook.then((book) async {
    final savedBooksNotifier = ref.read(savedBooksProvider.notifier);
    await savedBooksNotifier.updateSavedBook(isbn, book);
    return book;
  });
});
