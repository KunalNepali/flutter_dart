import 'package:flutter/material.dart';
import 'entry_iii_page.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Expanded(
                flex: 4,
                child: Image.asset(
                  "assets/images/entry_I.png",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Be Prepared for Nepal police Exam",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              const Text(
                "New Syllabus, Selection Process,\nEnglish, Nepali, GK, IQ, Professional Knowledge,\nInterview and Past Questions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5BB9C1),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EntryIIIPage()),
                    );
                  },
                  child: const Text("Get Started"),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
