import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CVViewerPage extends StatelessWidget {
  const CVViewerPage({super.key});

  static const String assetPath = 'assets/cv/KaramKottishCV.pdf';

  @override
  Widget build(BuildContext context) {
    // For GitHub Pages project sites, the app is served under /My-Portfolio/
    final String webUrl =
        '${Uri.base.origin}/My-Portfolio/$assetPath'; // e.g., https://karamkottish.github.io/My-Portfolio/assets/cv/KaramKottishCV.pdf

    return Scaffold(
      appBar: AppBar(title: const Text('My CV')),
      body: kIsWeb
          ? SfPdfViewer.network(
        webUrl,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        onDocumentLoadFailed: (details) {
          // Helpful message if the file path is wrong in the deployment
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load PDF: ${details.description}')),
          );
        },
      )
          : SfPdfViewer.asset(
        assetPath,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load PDF: ${details.description}')),
          );
        },
      ),
    );
  }
}
