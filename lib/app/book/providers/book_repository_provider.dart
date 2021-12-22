import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbn_reader/infra/book/book_repository.dart';

final bookRepositoryProvider = Provider((_) {
  return BookRepository();
});
