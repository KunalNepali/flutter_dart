import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class PdfViewerScreen extends StatefulWidget {
  final String assetPath;

  const PdfViewerScreen({super.key, required this.assetPath});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    final data = await rootBundle.load(widget.assetPath);
    final bytes = data.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(bytes, flush: true);

    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(filePath: localPath!),
    );
  }
}
