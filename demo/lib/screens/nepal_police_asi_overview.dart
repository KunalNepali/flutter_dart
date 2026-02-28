import 'package:flutter/material.dart';
import 'package:demo/screens/pdf_viewer_screen.dart';

class NepalPoliceAsiOverview extends StatelessWidget {
  const NepalPoliceAsiOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            /// TOP HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // left spacing balance
                  const Text(
                    "Home - ASI",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const Icon(Icons.menu, size: 30),
                ],
              ),
            ),

            /// SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    _buildButton(
                      "Syllabus",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PdfViewerScreen(
                              assetPath: 'assets/pdf/asi_syllabus.pdf',
                            ),
                          ),
                        );
                      },
                    ),
                    _buildButton("I Paper"),
                    _buildButton("II Paper"),
                    _buildButton("III Paper"),
                    _buildButton("Interview"),
                    _buildButton("Police Act"),
                    _buildButton("Police Regulations"),
                    _buildButton("Past Questions"),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// BOTTOM BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("नेपा"),
                      Switch(value: false, onChanged: (val) {}),
                      const Text("ENG"),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable Pill Button
  Widget _buildButton(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFB7BEC5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
