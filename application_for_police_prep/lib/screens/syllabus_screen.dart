import 'package:flutter/material.dart';

class SyllabusScreen extends StatelessWidget {
  const SyllabusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nepal Police Exam Syllabus'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Nepal Police Exam Pattern'),
            _buildExamPattern(),
            _buildSectionTitle('ASI (Assistant Sub-Inspector) Exam'),
            _buildPhaseCard('First Phase',
                ['Application Screening', 'Initial Medical Check-up (IMCE)']),
            _buildPhaseCard('Second Phase', [
              'Physical Endurance Evaluation Test (PEET)',
              'Detailed Medical Check-up'
            ]),
            _buildPhaseCard('Third Phase - Written Examination', [
              'Paper I: General Ability and Reasoning Test (GART) - 100 marks',
              'Paper II: Language Proficiency Test (LPT) - 100 marks',
              'Paper III: Professional Orientation Aptitude Test (POAT) - 100 marks'
            ]),
            _buildPhaseCard('Fourth Phase', ['Special Medical Check-up']),
            _buildPhaseCard('Fifth Phase', [
              'Competency Test: Group Discussion - 10 marks',
              'Interview - 40 marks'
            ]),
            _buildSectionTitle('ASI Physical Standards (PEET)'),
            _buildPhysicalStandards(),
            _buildSectionTitle('ASI Paper I: General Ability & Reasoning'),
            _buildPaperDetails('Section A: General Knowledge (50 marks)', [
              'Geography of Nepal & World',
              'History, Culture & Social Status of Nepal',
              'Development Infrastructure in Nepal',
              'Environmental Conservation & Climate Change',
              'Computers, Mobile, Internet & Technology Impact',
              'UN & Nepal Police Participation',
              'SAARC, BIMSTEC, NATO, INTERPOL',
              'Current Affairs',
              'Constitution of Nepal',
              'Genes & Genetics',
              'Police Organization Information'
            ]),
            _buildPaperDetails('Section B: Reasoning Test (50 marks)', [
              'Verbal Reasoning (16 marks)',
              'Numerical Reasoning (10 marks)',
              'Arithmetical Test (10 marks)',
              'Non-Verbal Reasoning (14 marks)'
            ]),
            _buildSectionTitle('ASI Paper II: Language Proficiency'),
            _buildPaperDetails('English Language (50 marks)', [
              'Comprehension',
              'Vocabulary',
              'Translation',
              'Conversation/Summarization',
              'Essay Writing',
              'Short Report (Letter-form)',
              'Structure Testing'
            ]),
            _buildPaperDetails('Nepali Language (50 marks)',
                ['Nepali Writing', 'Nepali Grammar', 'Comprehension Skills']),
            _buildSectionTitle('ASI Paper III: Professional Knowledge'),
            _buildPaperDetails('Part I: Professional Knowledge (85 marks)', [
              'Nepal Police Introduction',
              'Security System',
              'Crime & Investigation',
              'Police Management',
              'Legal System'
            ]),
            _buildPaperDetails(
                'Part II: Professional Behavioral Test (15 marks)', [
              'Situational Travel Time',
              'Incident Report Writing',
              'Simulation/Work Sample'
            ]),
            _buildSectionTitle('Inspector Level Exam'),
            _buildPhaseCard('First Phase',
                ['Application Screening', 'Initial Medical Check-up (IMCE)']),
            _buildPhaseCard('Second Phase', [
              'Physical Endurance Evaluation Test (PEET)',
              'Detailed Medical Check-up'
            ]),
            _buildPhaseCard('Third Phase - Written Examination', [
              'Paper I: General Ability and Reasoning Test (GART) - 100 marks',
              'Paper II: Language Proficiency Test (LPT) - 100 marks',
              'Paper III: Professional Orientation Aptitude Test (POAT) - 100 marks'
            ]),
            _buildPhaseCard('Fourth Phase', ['Special Medical Check-up']),
            _buildPhaseCard('Fifth Phase', [
              'Competency Test: Presentation - 10 marks',
              'Competency Based Interview - 40 marks'
            ]),
            _buildSectionTitle('Inspector Exam Syllabus'),
            _buildPaperDetails('Paper I: General Knowledge (Enhanced)', [
              'World History Major Events',
              'Ancient & Medieval History of Nepal',
              'Development Plans of Nepal',
              'Bilateral & Multilateral Development',
              'Environmental Status & Protection',
              'Latest Technology Impact',
              'International Organizations',
              'Current Affairs',
              'Constitution Details',
              'Forensic Science Basics',
              'Security Agencies Information'
            ]),
            _buildPaperDetails('Paper III: Professional Knowledge (Advanced)', [
              'Police Introduction & Qualities',
              'Security Planning & Implementation',
              'Internal & External Security Challenges',
              'Security Provisions & Coordination',
              'Crisis Management',
              'Crime & Investigation',
              'Crime Scene Management',
              'Police Management',
              'Legal System & Acts'
            ]),
            _buildSectionTitle('Competency Test Details'),
            _buildCompetencyTest(),
            _buildSectionTitle('Important Notes'),
            _buildImportantNotes(),
            _buildSectionTitle('Preparation Tips'),
            _buildTipsSection(),
            const SizedBox(height: 30),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildExamPattern() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Exam Pattern Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Post',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Total Marks',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Written',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Interview',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                TableRow(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('ASI'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('250'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('200'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('50'),
                    ),
                  ],
                ),
                TableRow(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Inspector'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('250'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('200'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('50'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseCard(String phaseTitle, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phaseTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_right,
                        size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalStandards() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Physical Endurance Test Standards',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Test',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Male (Pass)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Female (Pass)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                TableRow(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('300m Run'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('≤55 sec'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('≤67 sec'),
                    ),
                  ],
                ),
                TableRow(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('High Jump'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('≥3 ft'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('≥2 ft'),
                    ),
                  ],
                ),
                TableRow(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Sit-up'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('≥12 times'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('≥5 times'),
                    ),
                  ],
                ),
                TableRow(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Push-up'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('≥10 times'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('≥4 times'),
                    ),
                  ],
                ),
                TableRow(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('3.2km Run'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('≤18 min'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('≤21 min'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaperDetails(String title, List<String> topics) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            ...topics.map((topic) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 8),
                child: Text(
                  '• $topic',
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetencyTest() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Competency Assessment Areas:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildCompetencyItem(
                'Integrity', 'Professional ethics & moral values'),
            _buildCompetencyItem(
                'Professional Policing', 'Technical knowledge & skills'),
            _buildCompetencyItem(
                'Public Orientation', 'Community service approach'),
            _buildCompetencyItem('Communication', 'Verbal & written skills'),
            _buildCompetencyItem('Leadership', 'Team management & guidance'),
            _buildCompetencyItem(
                'Planning & Coordination', 'Organizational skills'),
            _buildCompetencyItem('Problem Solving', 'Analytical thinking'),
            _buildCompetencyItem(
                'Result Orientation', 'Goal achievement focus'),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetencyItem(String competency, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.check, size: 14, color: Colors.blue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  competency,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotes() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Important Notes for Candidates',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildNoteItem('Exam Medium', 'Nepali or English or both'),
            _buildNoteItem(
                'Negative Marking', '20% deduction for wrong answers in MCQs'),
            _buildNoteItem(
                'Question Types', 'Objective (MCQs) & Subjective questions'),
            _buildNoteItem(
                'Syllabus Updates', 'Follow latest police notifications'),
            _buildNoteItem('Medical Standards',
                'As per Police Service Medical Standards 2069'),
            _buildNoteItem(
                'Document Verification', 'Original certificates required'),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Preparation Strategy',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('📚', 'Study Police Regulation 2071 thoroughly'),
            _buildTipItem('📰', 'Read daily newspapers for current affairs'),
            _buildTipItem('⚖️', 'Focus on legal acts and constitution'),
            _buildTipItem('💪', 'Start physical training 3 months before exam'),
            _buildTipItem('🧠', 'Practice reasoning questions daily'),
            _buildTipItem('📝', 'Write practice essays in both languages'),
            _buildTipItem('🕐', 'Practice with time management'),
            _buildTipItem('👥', 'Join group discussions for interview prep'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          const Icon(Icons.info, color: Colors.blue, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Official Syllabus Source:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nepal Police Headquarters\nHuman Resource Development Department\nSelection Branch, Naxal, Kathmandu',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.blue),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Note: Always refer to the official Nepal Police notification\nfor the latest syllabus updates and exam dates.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Best Wishes for Your Preparation!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
