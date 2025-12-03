import 'package:deteksi_cemas/features/dashboard/presentation/screens/article_screen.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/screens/history_screen.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/screens/home_screen.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/screens/record_screen.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/screens/setting_screen.dart';
import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with SingleTickerProviderStateMixin {
  String _userName = '';
  int _currentPage = 0;
  bool _isLoading = false;
  late AnimationController _fabAnimationController;
  late Animation<Offset> _fabSlideAnimation;

  late ScrollController _scrollController;
  bool _isVisible = true; // State for bottom bar visibility
  double _previousScrollOffset = 0.0;

  List<Widget Function(ScrollController? controller)> get _pageBuilders => [
    (controller) => HomeScreen(controller: controller, name: _userName),
    (controller) => HistoryScreen(controller: controller),
    (controller) =>
        RecordScreen(controller: controller, backtohome: backToHomescreen),
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

    // Initial state setup: Home (Index 0) is visible
    _fabAnimationController.forward();
    _isVisible = true;

    // Listen for scroll changes only on scrollable pages (like Home)
    _scrollController.addListener(_scrollListener);
  }

  Future<void> printToken() async {
    final tokenService = TokenStorageService();

    // Use 'await' to pause execution until the Future completes and returns the String? value.
    String? token = await tokenService.readToken();

    // Now you can print the actual token or null
    if (kDebugMode) {
      print('Token: $token');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO: Fix user name on home screen
    // Check if the userName has NOT been set yet (to avoid reading arguments multiple times)
    if (_userName.isEmpty || _userName == 'Pengguna') {
      // Access the arguments from the route settings
      final args = ModalRoute.of(context)!.settings.arguments;
      final Map<String, dynamic>? arguments = args as Map<String, dynamic>?;
      final receivedUserName = arguments?['userName'] ?? 'Pengguna';

      // Use setState to update _userName.
      // This is crucial: setState triggers the build method, which re-evaluates the _pageBuilders getter.
      if (_userName != receivedUserName) {
        setState(() {
          _userName = receivedUserName;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // CRITICAL FIX: Do not run scroll logic on the Record Screen
    if (_currentPage == 2) return;

    double currentScrollOffset = _scrollController.offset;
    const double scrollBuffer = 50.0;

    // --- Scrolling Down (HIDE) ---
    if (currentScrollOffset > _previousScrollOffset &&
        currentScrollOffset > scrollBuffer) {
      if (_isVisible) {
        _fabAnimationController.forward(); // Hide FAB (slide out)
        setState(() {
          _isVisible = false; // Hide Nav Bar
        });
      }
    }
    // --- Scrolling Up (SHOW) ---
    else if (currentScrollOffset < _previousScrollOffset) {
      if (!_isVisible) {
        _fabAnimationController.reverse(); // Show FAB (slide in)
        setState(() {
          _isVisible = true; // Show Nav Bar
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
    await Future.delayed(const Duration(milliseconds: 300));

    // 3. Update page index and end loading state
    setState(() {
      _currentPage = index;
      _isLoading = false;
    });

    // 4. CRITICAL FIX: Control visibility immediately after page switch
    if (index == 2) {
      // Record Screen selected (Index 2): Hide nav bar and animate FAB out
      setState(() {
        _isVisible = false;
      });
      _fabAnimationController.animateTo(1.0); // Animate to end (hidden)
    } else {
      // Any other screen selected: Show nav bar and animate FAB in
      setState(() {
        _isVisible = true;
      });
      _fabAnimationController.animateBack(0.0); // Animate to start (visible)
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // 1. canPop: This is TRUE for ALL screens EXCEPT the Record Screen (Index 2).
      //    - Index 0, 1, 3, 4: canPop is TRUE, so the back button proceeds to exit the app.
      //    - Index 2: canPop is FALSE, so the default exit is blocked, and we execute custom logic.
      canPop: _currentPage != 2,

      // 2. onPopInvokedWithResult: The callback to run when a pop event is triggered.
      onPopInvokedWithResult: (didPop, result) {
        // If didPop is true, it means canPop was true (we allowed the default pop),
        // so we don't need to do anything else.
        if (didPop) return;

        // EXECUTES ONLY WHEN on Index 2 (RecordScreen)
        // Since canPop was FALSE, we are guaranteed to be on the RecordScreen.

        // Custom logic: Switch back to the default tab (Index 0)
        setState(() {
          _currentPage = 0;
          _isVisible = true;
        });

        // IMPORTANT FIX: Animate FAB back in
        _fabAnimationController.animateBack(0.0);

        // Show a temporary message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Returned to Home from Record Screen!'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                )
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
      ),
    );
  }

  void backToHomescreen() {
    setState(() {
      _currentPage = 0;
    });
  }
}
