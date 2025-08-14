import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CVViewerPage extends StatelessWidget {
  const CVViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My CV")),
      body: SfPdfViewer.asset('assets/cv/KaramKottishCV.pdf'),
    );
  }
}
