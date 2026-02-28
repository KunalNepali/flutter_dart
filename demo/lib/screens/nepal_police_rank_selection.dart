import 'package:flutter/material.dart';
import 'package:demo/screens/nepal_police_asi_overview.dart';

class NepalPoliceRankSelection extends StatelessWidget {
  const NepalPoliceRankSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            /// SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    /// Title
                    const Text(
                      "Which Rank are you preparing for?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 50),

                    /// Police Constable
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/constable.png',
                            height: 60,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Police Constable",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    /// ASI
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NepalPoliceAsiOverview(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset('assets/images/asi.png', height: 70),
                          const SizedBox(height: 15),
                          const Text(
                            "Assistant Sub-\nInspector (ASI)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    /// Police Inspector
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/inspector.png',
                            height: 70,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Police Inspector",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
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
                  /// Language Toggle
                  Row(
                    children: [
                      const Text("नेपा"),
                      Switch(value: false, onChanged: (val) {}),
                      const Text("ENG"),
                    ],
                  ),

                  /// Back Button
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
}
