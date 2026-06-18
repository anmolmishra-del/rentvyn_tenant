import 'package:flutter/material.dart';
import 'package:rentvyn_tenant/features/auth/views/login_screen.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../explore/views/explore_pgs_view.dart';
import '../../../core/constants/app_colors.dart';

class MainNavView extends StatefulWidget {
  const MainNavView({super.key});

  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  int _selectedTab = 0; // 0: My PGs (Light Blue), 1: Explore (Light Violet)
  bool _isLoggedIn = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
      _selectedTab = 0;
    });
    _pageController.jumpToPage(0);
  }

  void _onLogout() {
    setState(() {
      _isLoggedIn = false;
      _selectedTab = 0;
    });
    _pageController.jumpToPage(0);
  }

  void _navigateToTab(int index) {
    setState(() {
      _selectedTab = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showNavBar = !_isLoggedIn;

    // Curated nav pill colors for better contrast and consistency
    final Color portalSelectedBg = AppColors.primary.withOpacity(0.18);
    const Color portalSelectedFg = AppColors.primary;
    final Color portalUnselectedBg = Colors.white;

    final Color exploreSelectedBg = AppColors.secondary.withOpacity(0.18);
    const Color exploreSelectedFg = AppColors.secondary;
    final Color exploreUnselectedBg = Colors.white;

    return Scaffold(
      extendBody: showNavBar,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Page 0: My PGs (Login or Dashboard)
          _isLoggedIn
              ? DashboardView(onLogout: _onLogout)
              : LoginScreen(onLoginSuccess: _onLoginSuccess),
          
          // Page 1: Explore PGs
          const ExplorePgsView(isNested: true),
        ],
      ),
      bottomNavigationBar: showNavBar
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(45),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // --- MY PGs CONTROL (Left Side) ---
                        _selectedTab == 0
                            ? Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 350),
                                  height: 70,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(color: portalSelectedFg.withOpacity(0.18), width: 1.5),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: portalSelectedFg.withOpacity(0.12),
                                    //     blurRadius: 18,
                                    //     offset: const Offset(0, 6),
                                    //   )
                                    // ],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.home_work_rounded, color: Colors.white, size: 24),
                                        const SizedBox(width: 8),
                                        Text(
                                          'My PGs',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () => _navigateToTab(0),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: portalSelectedFg.withOpacity(0.12), width: 1),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: portalSelectedFg.withOpacity(0.05),
                                    //     blurRadius: 12,
                                    //     offset: const Offset(0, 4),
                                    //   )
                                    // ],
                                  ),
                                  child: Icon(Icons.home_work_rounded, color: Colors.white, size: 26),
                                ),
                              ),

                        // --- EXPLORE CONTROL (Right Side) ---
                        _selectedTab == 1
                            ? Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 350),
                                  height: 70,
                                  margin: const EdgeInsets.only(left: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(color: exploreSelectedFg.withOpacity(0.18), width: 1.5),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     // color: exploreSelectedFg.withOpacity(0.12),
                                    //     blurRadius: 18,
                                    //     offset: const Offset(0, 6),
                                    //   )
                                    // ],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.explore_rounded, color: Colors.white, size: 24),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Explore',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () => _navigateToTab(1),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: exploreSelectedFg.withOpacity(0.12), width: 1),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: exploreSelectedFg.withOpacity(0.05),
                                    //     blurRadius: 12,
                                    //     offset: const Offset(0, 4),
                                    //   )
                                    // ],
                                  ),
                                  child: Icon(Icons.explore_rounded, color: Colors.white, size: 26),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
