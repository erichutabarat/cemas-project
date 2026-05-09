import 'package:deteksi_cemas/features/dashboard_admin/presentation/screens/article_admin_screen.dart';
import 'package:deteksi_cemas/features/dashboard_admin/presentation/screens/home_admin_screen.dart';
import 'package:deteksi_cemas/features/dashboard_admin/presentation/screens/medical_admin_screen.dart';
import 'package:deteksi_cemas/features/dashboard_admin/presentation/screens/question_admin_screen.dart';
import 'package:deteksi_cemas/features/dashboard_admin/presentation/screens/setting_admin_screen.dart';
import 'package:flutter/material.dart';

class DashboardAdminLayout extends StatefulWidget {
  const DashboardAdminLayout({super.key});

  @override
  State<DashboardAdminLayout> createState() => _DashboardAdminLayoutState();
}

class _DashboardAdminLayoutState extends State<DashboardAdminLayout> {
  int _currentPage = 0;

  final List<Widget> _adminPages = [
    HomeAdminScreen(),
    MedicalAdminScreen(),
    QuestionAdminScreen(),
    ArticleAdminScreen(),
    SettingAdminScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: _adminPages[_currentPage],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10), // Memberikan efek floating
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
          child: BottomNavigationBar(
            backgroundColor:
                Colors.transparent, // Agar menyatu dengan Container
            elevation: 0,
            currentIndex: _currentPage,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(
              0xFF1E3A8A,
            ), // Warna biru senada header
            unselectedItemColor: Colors.grey[400],
            showSelectedLabels: true,
            showUnselectedLabels:
                false, // Hanya label aktif yang muncul agar rapi
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            onTap: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            items: [
              _buildNavItem(Icons.home_rounded, "Home", 0),
              _buildNavItem(
                Icons.medical_services_rounded,
                "Medical Record",
                1,
              ),
              _buildNavItem(Icons.quiz_rounded, "HARS Survey", 2),
              _buildNavItem(Icons.article_rounded, "Articles", 3),
              _buildNavItem(Icons.settings_rounded, "Settings", 4),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(_currentPage == index ? 8 : 0),
        decoration: BoxDecoration(
          color: _currentPage == index
              ? const Color(0xFF1E3A8A).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
