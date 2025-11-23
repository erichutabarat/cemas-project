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

class _DashboardLayoutState extends State<DashboardLayout>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  bool _isLoading = false;

  late AnimationController _fabAnimationController;
  late Animation<Offset> _fabSlideAnimation;

  late ScrollController _scrollController;
  bool _isVisible = true; // State for bottom bar visibility
  double _previousScrollOffset = 0.0;

  final List<Widget Function(ScrollController? controller)> _pageBuilders = [
    (controller) => HomeScreen(controller: controller),
    (controller) => HistoryScreen(controller: controller),
    (controller) => RecordScreen(controller: controller),
    (controller) => ArticleScreen(controller: controller),
    (controller) => SettingScreen(controller: controller),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fabSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 2),
    ).animate(_fabAnimationController);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    double currentScrollOffset = _scrollController.offset;

    // --- Scrolling Down (HIDE) ---
    // Ensure we've scrolled past a small buffer (50.0) to prevent accidental hides
    if (currentScrollOffset > _previousScrollOffset &&
        currentScrollOffset > 50.0) {
      if (_isVisible) {
        // 1. Start the hide animation (slide out)
        _fabAnimationController.forward();

        // 2. Update state to reflect hidden status
        setState(() {
          _isVisible = false;
        });
      }
    }
    // --- Scrolling Up (SHOW) ---
    else if (currentScrollOffset < _previousScrollOffset) {
      if (!_isVisible) {
        // 1. Start the show animation (slide in)
        _fabAnimationController.reverse();

        // 2. Update state to reflect visible status
        setState(() {
          _isVisible = true;
        });
      }
    }

    _previousScrollOffset = currentScrollOffset;
  }

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
      resizeToAvoidBottomInset: false,
      body: Container(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.red))
            : Padding(
                padding: const EdgeInsets.all(0),
                child: SafeArea(
                  child: _pageBuilders[_currentPage](_scrollController),
                ),
              ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Animation speed
        height: _isVisible
            ? kBottomNavigationBarHeight + 8.0
            : 0.0, // kBottomNavigationBarHeight is standard
        child: Wrap(
          // Use Wrap to prevent vertical overflow when height is zero
          children: [
            BottomNavigationBar(
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SlideTransition(
        position:
            _fabSlideAnimation, // The animation that drives the vertical movement
        child: FloatingActionButton(
          backgroundColor: Colors.red.shade400,
          onPressed: () {
            _onItemTapped(2);
          },
          tooltip: 'Record Page',
          shape: const CircleBorder(),
          child: const Icon(Icons.mic_rounded, color: Colors.black54),
        ),
      ),
    );
  }
}
