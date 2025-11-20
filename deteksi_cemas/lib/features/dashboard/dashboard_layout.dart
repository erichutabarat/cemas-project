import 'package:deteksi_cemas/features/dashboard/presentation/screens/article_screen.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/screens/history_screen.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/screens/home_screen.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/screens/record_screen.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/screens/setting_screen.dart';
import 'package:flutter/material.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int _currentPage = 0;
  bool _isLoading = false;

  final List<Widget> _pages = [
    HomeScreen(),
    HistoryScreen(),
    RecordScreen(),
    ArticleScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) async {
    // Prevent changing the current page if it's already loading
    if (_isLoading) return;

    // 1. Start loading state
    setState(() {
      _isLoading = true;
    });

    // 2. Add your desired delay (e.g., 500 milliseconds)
    await Future.delayed(const Duration(milliseconds: 500));

    // 3. Update page index and end loading state
    setState(() {
      _currentPage = index;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.red))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: SafeArea(child: _pages.elementAt(_currentPage)),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,

        // --- STYLED PROPERTIES ---
        backgroundColor: Colors.white,
        elevation: 4.0,

        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blueGrey[400],

        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        // -------------------------
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 32),
            activeIcon: Icon(Icons.home_filled, size: 32),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined, size: 32),
            activeIcon: Icon(Icons.history_rounded, size: 32),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(), // Empty space for the FAB
            label: "Record",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined, size: 32),
            activeIcon: Icon(Icons.article_rounded, size: 32),
            label: "Article",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: 32),
            activeIcon: Icon(Icons.settings_rounded, size: 32),
            label: "Settings",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade400,
        onPressed: () {
          _onItemTapped(2);
        },
        tooltip: 'Record Page',
        shape: const CircleBorder(),
        child: Icon(Icons.mic_rounded, color: Colors.black54),
      ),
    );
  }
}
