import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbn_scanner/infra/book/book_repository.dart';

final bookRepositoryProvider = Provider((_) {
  return BookRepository();
});
