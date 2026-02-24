import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Ketentuan Layanan",
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
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.gavel_rounded,
                  size: 40,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Syarat & Ketentuan Penggunaan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Efektif sejak: 24 Februari 2026",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const Divider(height: 40),

            _buildSection(
              "1. Penerimaan Ketentuan",
              "Dengan mengakses atau menggunakan aplikasi ini, Anda setuju untuk terikat oleh Ketentuan Layanan ini. Jika Anda tidak setuju, mohon untuk tidak menggunakan layanan kami.",
            ),

            _buildSection(
              "2. Bukan Pengganti Saran Medis",
              "PENTING: Aplikasi ini menggunakan teknologi AI untuk mendeteksi kecemasan. Hasil yang diberikan adalah bersifat informatif dan BUKAN merupakan diagnosa medis klinis yang final. Selalu konsultasikan hasil Anda dengan psikolog atau psikiater profesional.",
            ),

            _buildSection(
              "3. Penggunaan Perangkat Keras",
              "Layanan ini melibatkan penggunaan perangkat keras tambahan (ESP32). Pengguna bertanggung jawab penuh atas keamanan fisik perangkat tersebut dan memastikan penggunaan yang benar sesuai instruksi agar mendapatkan data detak jantung yang akurat.",
            ),

            _buildSection(
              "4. Batasan Tanggung Jawab",
              "Kami tidak bertanggung jawab atas tindakan yang diambil pengguna berdasarkan hasil analisis aplikasi ini. Penyalahgunaan data atau kegagalan perangkat keras di luar kendali kami bukan merupakan tanggung jawab pengembang.",
            ),

            _buildSection(
              "5. Larangan Penggunaan",
              "Anda dilarang mencoba meretas, memodifikasi, atau melakukan reverse engineering pada sistem backend kami (erichutabarat.my.id) atau API aplikasi.",
            ),

            const SizedBox(height: 30),

            // Accept Button (Jika ini muncul saat pertama kali login/register)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Saya Mengerti & Setuju",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
