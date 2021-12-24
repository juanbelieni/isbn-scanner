abstract class IBook {
  String get isbn;
  String get title;
  List<String> get authors;
  double get rating;
  String get description;
  String get coverUrl;

  Map<String, dynamic> toJson();
}

abstract class IBookRepository {
  Future<IBook> getBookByIsbn(String isbn);
  Future<void> saveBook(IBook book);
  Future<void> removeBook(IBook book);
  Future<void> updateBook(String isbn, IBook book);
  Future<List<IBook>> getSavedBooks();
}
