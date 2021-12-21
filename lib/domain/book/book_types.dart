abstract class IBook {
  String get isbn;
  String get title;
  List<String> get authors;
  double get rating;
  String get description;
  String get coverUrl;
}

abstract class IBookRepository {
  Future<IBook> getBookByIsbn(String isbn);
}