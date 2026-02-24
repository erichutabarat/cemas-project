import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan intl di pubspec.yaml untuk format tanggal

class MedicalAdminScreen extends StatefulWidget {
  const MedicalAdminScreen({super.key});

  @override
  State<MedicalAdminScreen> createState() => _MedicalAdminScreenState();
}

class _MedicalAdminScreenState extends State<MedicalAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data dummy berdasarkan JSON Anda
  final List<Map<String, dynamic>> _records = [
    {
      "id": 1,
      "user_id": 1,
      "audio_url": "heartbeat_sample.wav",
      "checked": true,
      "created_at": "2025-12-06T14:19:25.599Z",
      "result": {"anxiety_level": "Moderate", "bpm": 80, "hrv": 72},
    },
    {
      "id": 2,
      "user_id": 2,
      "audio_url": "record.wav",
      "checked": false,
      "created_at": "2026-01-16T06:04:07.059Z",
    },
    {
      "id": 3,
      "user_id": 1,
      "audio_url": "record.wav",
      "checked": false,
      "created_at": "2026-01-16T06:04:07.059Z",
    },
    // ... data lainnya
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Medical Records",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E3A8A),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E3A8A),
          tabs: const [
            Tab(text: "Unchecked"),
            Tab(text: "Checked"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecordList(checked: false),
          _buildRecordList(checked: true),
        ],
      ),
    );
  }

  Widget _buildRecordList({required bool checked}) {
    final filteredList = _records
        .where((r) => r['checked'] == checked)
        .toList();

    if (filteredList.isEmpty) {
      return const Center(child: Text("Tidak ada data"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final data = filteredList[index];
        return _buildMedicalCard(data);
      },
    );
  }

  Widget _buildMedicalCard(Map<String, dynamic> data) {
    bool isChecked = data['checked'];
    String formattedDate = DateFormat(
      'dd MMM yyyy, HH:mm',
    ).format(DateTime.parse(data['created_at']));

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isChecked
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isChecked
                  ? Icons.check_circle_rounded
                  : Icons.pending_actions_rounded,
              color: isChecked ? Colors.green : Colors.orange,
            ),
          ),
          title: Text(
            "User ID: ${data['user_id']}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(formattedDate, style: const TextStyle(fontSize: 12)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(),
                  _buildDetailRow(
                    "Audio File",
                    data['audio_url'],
                    Icons.audiotrack,
                  ),
                  if (isChecked && data['result'] != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildResultBadge(
                          "BPM: ${data['result']['bpm']}",
                          Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        _buildResultBadge(
                          "Level: ${data['result']['anxiety_level']}",
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {}, // Play audio logic
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Play Audio"),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (!isChecked)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {}, // Action to process/check
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A8A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Process",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildResultBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
