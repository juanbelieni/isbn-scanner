import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbn_reader/app/book/providers/book_repository_provider.dart';
import 'package:isbn_reader/domain/book/book.dart';
import 'package:isbn_reader/infra/book/book_repository.dart';

class SavedBooksNotifier extends StateNotifier<List<Book>> {
  final BookRepository bookRepository;

  SavedBooksNotifier({required this.bookRepository}) : super([]) {
    loadSavedBooks();
  }

  Future<void> loadSavedBooks() async {
    state = await bookRepository.getSavedBooks();
  }

  Future<void> toggleBookmark(Book book) async {
    final isBookmarked = state.any((bookmark) => bookmark.isbn == book.isbn);

    if (isBookmarked) {
      await bookRepository.removeBook(book);
    } else {
      await bookRepository.saveBook(book);
    }

    await loadSavedBooks();
  }
}

final savedBooksProvider =
    StateNotifierProvider<SavedBooksNotifier, List<Book>>((ref) {
  final bookRepository = ref.read(bookRepositoryProvider);
  return SavedBooksNotifier(bookRepository: bookRepository);
});
