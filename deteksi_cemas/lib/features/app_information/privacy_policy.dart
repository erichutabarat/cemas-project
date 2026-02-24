import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Kebijakan Privasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Privasi Anda adalah Prioritas Kami",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Terakhir diperbarui: 24 Februari 2026",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const Divider(height: 40),

            _buildSection(
              "1. Informasi yang Kami Kumpulkan",
              "Kami mengumpulkan data yang Anda berikan secara langsung, termasuk namun tidak terbatas pada:\n"
                  "• Data Akun (Nama, Email)\n"
                  "• Rekaman Detak Jantung (Audio) untuk analisis kecemasan\n"
                  "• Hasil kuesioner HARS (Hamilton Anxiety Rating Scale)",
            ),

            _buildSection(
              "2. Bagaimana Kami Menggunakan Data",
              "Data Anda digunakan semata-mata untuk:\n"
                  "• Memberikan hasil analisis deteksi kecemasan\n"
                  "• Menyimpan riwayat pemeriksaan medis (Medical Records)\n"
                  "• Memantau perkembangan kesehatan mental Anda melalui sistem.",
            ),

            _buildSection(
              "3. Keamanan Data Biometrik",
              "Mengingat sensitivitas data rekaman detak jantung, kami menerapkan enkripsi pada transmisi data dan penyimpanan server untuk memastikan informasi Anda tidak disalahgunakan oleh pihak ketiga.",
            ),

            _buildSection(
              "4. Akses Administrator",
              "Data Anda hanya dapat diakses oleh administrator sistem untuk tujuan validasi medis dan pengembangan akurasi model deteksi kecemasan.",
            ),

            const SizedBox(height: 30),

            // Footer Contact
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Hubungi Kami",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Jika Anda memiliki pertanyaan tentang kebijakan ini, hubungi kami di: admin@erichutabarat.my.id",
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
