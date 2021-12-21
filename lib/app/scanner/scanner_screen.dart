import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:isbn_reader/app/book/book_details_screen.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  void _scan(BuildContext context) async {
    final barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.BARCODE,
    );

    if (barcode != '-1') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookDetailsScreen(
            isbn: barcode,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _scan(context),
          child: const Text('Scan'),
        ),
      ),
    );
  }
}
