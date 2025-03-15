import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:trackerapp/res/colors.dart';

class PDFview extends StatefulWidget {
  const PDFview({super.key});

  @override
  State<PDFview> createState() => _PDFviewState();
}

class _PDFviewState extends State<PDFview> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            mini: true,
            backgroundColor: AppColors.buttonColor,
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 300));
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Container(
            child: SfPdfViewer.network(
                'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf')));
  }
}
