import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Tentang Aplikasi",
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
        child: Column(
          children: [
            const SizedBox(height: 40),
            // App Logo & Version
            Center(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E3A8A).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "MySDLC - Anxiety Detection",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Versi 1.0.0",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Deskripsi Proyek",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Aplikasi ini dikembangkan untuk mendeteksi tingkat kecemasan pengguna secara objektif melalui analisis detak jantung (heartbeat) yang ditangkap menggunakan perangkat ESP32 dan diproses dengan algoritma Machine Learning.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Metode ini dikombinasikan dengan kuesioner HARS (Hamilton Anxiety Rating Scale) untuk memberikan hasil diagnosa awal yang komprehensif terkait kondisi kesehatan mental pengguna.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  const Divider(height: 40),

                  // Technology Stack
                  const Text(
                    "Teknologi yang Digunakan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTechTile(Icons.code, "Backend", "Golang (Go)"),
                  _buildTechTile(
                    Icons.flutter_dash,
                    "Mobile",
                    "Flutter (Dart)",
                  ),
                  _buildTechTile(Icons.memory, "Hardware", "ESP32 Sensor"),
                  _buildTechTile(Icons.storage, "Database", "MySQL"),

                  const SizedBox(height: 40),

                  // Footer Copyright
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Dikembangkan oleh:",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Eric Daniel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "erichutabarat.my.id",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechTile(IconData icon, String label, String tech) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(tech, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
