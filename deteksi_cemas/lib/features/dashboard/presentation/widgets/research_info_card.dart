import 'package:flutter/material.dart';

class ResearchInfoCard extends StatelessWidget {
  const ResearchInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Judul Penelitian',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                fontSize: 14, // Label slightly bigger
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Perancangan Sistem Deteksi Tingkat Gangguan Kecemasan Berbasis Sinyal Phonocardiogram Menggunakan MFCC–SVM dan Pendekatan Design Thinking',
              // Increased from 16 to 18
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const Divider(height: 32),

            Wrap(
              // Using Wrap instead of Row to handle larger text overflow
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(Icons.category, 'Research & Development'),
                _buildInfoChip(Icons.location_on, 'ITERA'),
              ],
            ),
            const SizedBox(height: 24),
            _buildPoint(
              Icons.psychology,
              'Tujuan: Sistem deteksi kecemasan PCG (MFCC-SVM).',
            ),
            _buildPoint(
              Icons.assignment,
              'Prosedur: Kuesioner HARS & data detak jantung (1 menit).',
            ),
            _buildPoint(
              Icons.verified_user,
              'Keamanan: Tidak ada risiko fisik/psikologis.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.indigo),
          const SizedBox(width: 6),
          Text(
            label,
            // Increased from 12 to 14
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPoint(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.indigo),
          const SizedBox(width: 12),
          // Increased from 13 to 15
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
