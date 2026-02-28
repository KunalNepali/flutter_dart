import 'package:flutter/material.dart';
import 'nepal_police_rank_selection.dart';

class FieldSelect extends StatelessWidget {
  const FieldSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// TOP HEADER (Fixed)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(color: Color(0xFF5FA8D3)),
              child: Column(
                children: const [
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Welcome Kunal Nepali!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            /// SCROLLABLE SECTION
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    const Text(
                      "Choose your field of interest",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// 🔵 Nepal Police (FIXED NAVIGATION HERE)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NepalPoliceRankSelection(),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/np.jpg'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// 🟢 Nepal Army
                    GestureDetector(
                      onTap: () {
                        // TODO: Add army navigation here
                      },
                      child: Image.asset('assets/images/na.png', height: 100),
                    ),

                    const SizedBox(height: 40),

                    /// 🔴 APF
                    GestureDetector(
                      onTap: () {
                        // TODO: Add APF navigation here
                      },
                      child: Image.asset('assets/images/apf.png', height: 100),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            /// BOTTOM BAR (Fixed)
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
}
