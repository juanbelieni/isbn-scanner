import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbn_scanner/app/book/providers/book_repository_provider.dart';
import 'package:isbn_scanner/domain/book/book.dart';
import 'package:isbn_scanner/infra/book/book_repository.dart';

class SavedBooksNotifier extends StateNotifier<List<IBook>> {
  final IBookRepository bookRepository;

  SavedBooksNotifier({required this.bookRepository}) : super([]) {
    loadSavedBooks();
  }

  Future<void> loadSavedBooks() async {
    state = await bookRepository.getSavedBooks();
  }

  Future<void> toggleSavedBook(IBook book) async {
    final isBookmarked = state.any((bookmark) => bookmark.isbn == book.isbn);

    if (isBookmarked) {
      await bookRepository.removeBook(book);
    } else {
      await bookRepository.saveBook(book);
    }

    await loadSavedBooks();
  }

  Future<void> updateSavedBook(String isbn, IBook book) async {
    print('$isbn: ${book.rating}');
    await bookRepository.updateBook(isbn, book);
    await loadSavedBooks();
  }
}

final savedBooksProvider =
    StateNotifierProvider<SavedBooksNotifier, List<IBook>>(
  (ref) {
    final bookRepository = ref.read(bookRepositoryProvider);
    return SavedBooksNotifier(bookRepository: bookRepository);
  },
);
