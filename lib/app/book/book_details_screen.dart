import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isbn_reader/app/book/book_provider.dart';
import 'package:isbn_reader/domain/book/book.dart';
import 'package:url_launcher/url_launcher.dart';
class BookDetailsScreen extends ConsumerWidget {
  final String isbn;

  const BookDetailsScreen({
    required this.isbn,
    Key? key,
  }) : super(key: key);

  String get _amazonUrl =>
      'https://www.amazon.com/s?k=${isbn.replaceAll('-', '')}';

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_left_rounded, size: 32),
        color: Colors.black,
        onPressed: () => Navigator.of(context).pop(),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark_border_outlined),
          color: Colors.black,
          onPressed: () => print('Bookmark'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBookDetails(BuildContext context, Book book) {
    return ListView(
      padding: const EdgeInsets.all(24),
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
        Text(
          book.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          book.authors[0],
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
          onPressed: () {
            // Redirect to Amazon website
            launch(_amazonUrl);
          },
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookProvider(isbn));

    return Scaffold(
      appBar: _buildAppBar(context),
      body: book.map(
        data: (_) => _buildBookDetails(context, _.value),
        loading: (_) => const Center(child: CircularProgressIndicator()),
        error: (_) => Center(child: Text(_.error.toString())),
      ),
    );
  }
}
