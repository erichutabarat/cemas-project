import 'package:flutter/material.dart';

class QuestionAdminScreen extends StatefulWidget {
  const QuestionAdminScreen({super.key});

  @override
  State<QuestionAdminScreen> createState() => _QuestionAdminScreenState();
}

class _QuestionAdminScreenState extends State<QuestionAdminScreen> {
  // Data dummy berdasarkan struktur JSON Anda
  final List<Map<String, dynamic>> _questions = [
    {
      "id": 1,
      "category": "Anxious Mood",
      "question_id": "Suasana hati cemas",
      "symptom_type": "Psychic",
      "options": [
        {"option_id": "Perasaan cemas atau khawatir berlebihan", "score": 1},
        {"option_id": "Firasat buruk", "score": 1},
        {"option_id": "Takut tanpa alasan yang jelas", "score": 1},
      ],
    },
    {
      "id": 2,
      "category": "Tension",
      "question_id": "Ketegangan",
      "symptom_type": "Psychic",
      "options": [
        {"option_id": "Merasa gelisah", "score": 1},
        {"option_id": "Sulit untuk rileks", "score": 1},
        {"option_id": "Mudah terkejut", "score": 1},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Kelola Pertanyaan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // Logic tambah pertanyaan baru
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                _buildChip("Total: ${_questions.length} Kategori", Colors.blue),
                const SizedBox(width: 8),
                _buildChip("Skala HARS", Colors.orange),
              ],
            ),
          ),

          // List Pertanyaan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final q = _questions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
                      child: Text(
                        "${q['id']}",
                        style: const TextStyle(
                          color: Color(0xFF1E3A8A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      q['question_id'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text("${q['category']} • ${q['symptom_type']}"),
                    children: [
                      const Divider(height: 1),
                      // Loop Opsi/Gejala
                      ...(q['options'] as List)
                          .map(
                            (opt) => ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: Colors.green,
                              ),
                              title: Text(opt['option_id']),
                              trailing: Text(
                                "Score: ${opt['score']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),

                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text("Edit"),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.delete,
                                size: 18,
                                color: Colors.red,
                              ),
                              label: const Text(
                                "Hapus",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
