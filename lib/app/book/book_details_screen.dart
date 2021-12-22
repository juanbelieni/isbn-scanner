import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isbn_scanner/app/book/providers/book_provider.dart';
import 'package:isbn_scanner/app/shared/providers/saved_books_provider.dart';
import 'package:isbn_scanner/domain/book/book.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailsScreen extends ConsumerStatefulWidget {
  final String isbn;

  const BookDetailsScreen({
    Key? key,
    required this.isbn,
  }) : super(key: key);

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  @override
  void initState() {
    final asyncBook = ref.read(bookProvider(widget.isbn));

    asyncBook.mapOrNull(
      error: (error) => ref.refresh(bookProvider(widget.isbn)),
    );

    super.initState();
  }

  String _getAmazonSearchUrl(Book book) {
    return 'https://www.amazon.com/s?k=${book.isbn}';
  }

  String _getGoodReadsBookUrl(Book book) {
    return 'https://www.goodreads.com/book/isbn/${book.isbn}';
  }

  void _handleSave() async {
    final notifier = ref.read(savedBooksProvider.notifier);
    final book = ref.read(bookProvider(widget.isbn)).value!;
    await notifier.toggleBookmark(book);

    final savedBooks = ref.read(savedBooksProvider);
    final isSaved = savedBooks.any((book) => book.isbn == widget.isbn);

    final message = isSaved
        ? 'Book added to your saved books'
        : 'Book removed from your saved books';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ));
  }

  void _handleShare() async {
    final book = ref.read(bookProvider(widget.isbn)).value!;

    final title = book.title;
    final authors = book.authors.join(', ');
    final url = _getGoodReadsBookUrl(book);

    final message = '$title by $authors\n\n$url';

    await Share.share(message);
  }

  void _handleRefresh() {
    ref.refresh(bookProvider(widget.isbn));
  }

  Widget _buildBookDetails() {
    final book = ref.read(bookProvider(widget.isbn)).value!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.coverUrl,
                width: min(MediaQuery.of(context).size.width * 0.8, 240),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SelectableText(
          book.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        SelectableText(
          book.authors.join(', '),
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: RatingBar(
                initialRating: book.rating,
                allowHalfRating: true,
                itemCount: 5,
                ignoreGestures: true,
                itemSize: 16,
                onRatingUpdate: (_) {},
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: Colors.amber),
                  half: const Icon(Icons.star_half, color: Colors.amber),
                  empty: const Icon(Icons.star_border, color: Colors.amber),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text.rich(
              TextSpan(
                text: '${book.rating.toStringAsFixed(1)} ',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '/ 5.0',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          book.description,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => launch(_getAmazonSearchUrl(book)),
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Search on Amazon',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookError() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/clumsy.png', height: 240),
          const SizedBox(height: 24),
          Text(
            'Oops! Something went wrong.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: _handleRefresh,
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Refresh',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncBook = ref.watch(bookProvider(widget.isbn));
    final isBookLoaded = asyncBook.asData != null;

    final savedBooks = ref.watch(savedBooksProvider);
    final isSaved = savedBooks.any((book) => book.isbn == widget.isbn);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left, size: 32),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline),
            color: Colors.black,
            onPressed: isBookLoaded ? () => _handleSave() : null,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: Colors.black,
            onPressed: isBookLoaded ? () => _handleShare() : null,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: asyncBook.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildBookError(),
        data: (book) => _buildBookDetails(),
      ),
    );
  }
}
