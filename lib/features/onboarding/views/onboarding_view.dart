import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routes/app_routes.dart';
import '../models/onboarding_model.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingModel> _pages = const [
    OnboardingModel(
      title: 'Find Your Perfect PG',
      description: 'Explore premium hostels and PGs matching your budget and preferred amenities in just a few taps.',
      icon: Icons.search_rounded,
      backgroundColor: Color(0xFFE8EAF6), // Indigo light
    ),
    OnboardingModel(
      title: 'Quick & Secure Booking',
      description: 'Book your stay instantly. Upload KYC documents and sign lease agreements digitally with complete peace of mind.',
      icon: Icons.verified_user_rounded,
      backgroundColor: Color(0xFFE0F2F1), // Teal light
    ),
    OnboardingModel(
      title: 'Seamless Payments',
      description: 'Pay your monthly rent, track security deposits, and request maintenance services directly through the app.',
      icon: Icons.payments_rounded,
      backgroundColor: Color(0xFFF1F8E9), // Green light
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _navigateToDashboard();
    }
  }

  void _navigateToDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (_currentIndex + 1) / _pages.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6), // Warm off-white
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background shapes
            Positioned(
              top: -100,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.03),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Column(
              children: [
                // Top Header actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Steps indicator text
                      Text(
                        '${_currentIndex + 1} / ${_pages.length}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      TextButton(
                        onPressed: _navigateToDashboard,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Slide Builder
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Illustration circle with concentric rings
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 260,
                                  height: 260,
                                  decoration: BoxDecoration(
                                    color: page.backgroundColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 220,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    color: page.backgroundColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 15,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    page.icon,
                                    size: 96,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 48),
                            // Slide Title
                            Text(
                              page.title,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1E1E24), // Charcoal color
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Slide Description
                            Text(
                              page.description,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                                height: 1.5,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Footer layout: dots indicators & circular progress button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Smooth indicators
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8.0),
                            height: 6.0,
                            width: _currentIndex == index ? 24.0 : 6.0,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                        ),
                      ),

                      // Premium Circular Progress Button
                      GestureDetector(
                        onTap: _nextPage,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 72,
                              height: 72,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 4.0,
                                backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                              ),
                            ),
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Icon(
                                _currentIndex == _pages.length - 1
                                    ? Icons.check_rounded
                                    : Icons.chevron_right_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
