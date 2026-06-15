import 'package:flutter/material.dart';
import '../../auth/views/otp_login_view.dart';
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
    });
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

    // Curated premium LIGHT pastel colors and deep foreground colors from AppColors
    final Color portalLightBg = AppColors.primary.withOpacity(0.08);
    const Color portalDarkFg = AppColors.primary;
    
    final Color exploreLightBg = AppColors.secondary.withOpacity(0.08);
    const Color exploreDarkFg = AppColors.secondary;

    return Scaffold(
      extendBody: showNavBar,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Page 0: My PGs (Login or Dashboard)
          _isLoggedIn
              ? DashboardView(onLogout: _onLogout)
              : OtpLoginView(onLoginSuccess: _onLoginSuccess),
          
          // Page 1: Explore PGs
          const ExplorePgsView(isNested: true),
        ],
      ),
      bottomNavigationBar: showNavBar
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
                                color: portalLightBg,
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(color: portalDarkFg.withOpacity(0.15), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: portalDarkFg.withOpacity(0.06),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.home_work_rounded, color: portalDarkFg, size: 24),
                                    SizedBox(width: 8),
                                    Text(
                                      'My PGs',
                                      style: TextStyle(
                                        color: portalDarkFg,
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
                                color: portalLightBg.withOpacity(0.8),
                                shape: BoxShape.circle,
                                border: Border.all(color: portalDarkFg.withOpacity(0.08), width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: portalDarkFg.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: const Icon(Icons.home_work_rounded, color: portalDarkFg, size: 26),
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
                                color: exploreLightBg,
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(color: exploreDarkFg.withOpacity(0.15), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: exploreDarkFg.withOpacity(0.06),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.explore_rounded, color: exploreDarkFg, size: 24),
                                    SizedBox(width: 8),
                                    Text(
                                      'Explore',
                                      style: TextStyle(
                                        color: exploreDarkFg,
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
                                color: exploreLightBg.withOpacity(0.8),
                                shape: BoxShape.circle,
                                border: Border.all(color: exploreDarkFg.withOpacity(0.08), width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: exploreDarkFg.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: const Icon(Icons.explore_rounded, color: exploreDarkFg, size: 26),
                            ),
                          ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
