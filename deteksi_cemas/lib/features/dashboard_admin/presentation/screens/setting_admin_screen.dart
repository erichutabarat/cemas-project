import 'package:flutter/material.dart';

class SettingAdminScreen extends StatelessWidget {
  const SettingAdminScreen({super.key});

  // Fungsi untuk memicu Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Konfirmasi Keluar"),
          content: const Text(
            "Apakah Anda yakin ingin keluar dari akun Admin?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Tambahkan logic pembersihan token/session di sini
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text(
                "Keluar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Pengaturan Admin",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Profil Singkat
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF1E3A8A),
              child: Icon(
                Icons.admin_panel_settings,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Administrator",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "admin@erichutabarat.my.id",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 2. Menu Group: Akun
            _buildSectionTitle("Akun"),
            _buildSettingItem(
              icon: Icons.person_outline,
              title: "Edit Profil",
              color: Colors.blue,
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: "Ganti Password",
              color: Colors.orange,
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // 3. Menu Group: Aplikasi
            _buildSectionTitle("Sistem"),
            _buildSettingItem(
              icon: Icons.notifications_none_outlined,
              title: "Notifikasi",
              color: Colors.purple,
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: "Versi Aplikasi",
              trailing: "v1.0.2",
              color: Colors.blueGrey,
              onTap: () {},
            ),

            const SizedBox(height: 40),

            // 4. Tombol Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                label: const Text(
                  "LOGOUT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  shadowColor: Colors.redAccent.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 10),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    String? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        trailing: trailing != null
            ? Text(trailing, style: const TextStyle(color: Colors.grey))
            : const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey,
              ),
      ),
    );
  }
}
