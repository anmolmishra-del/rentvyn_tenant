import 'package:flutter/material.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'home_tab.dart';
import 'accounts_tab.dart';
import 'tickets_tab.dart';
import 'profile_tab.dart';

class DashboardView extends StatefulWidget {
  final VoidCallback onLogout;
  const DashboardView({super.key, required this.onLogout});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      const HomeTab(),
      const AccountsTab(),
      const TicketsTab(),
      ProfileTab(onLogout: widget.onLogout),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: IndexedStack(
        index: _selectedIndex,
        children: tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 24),
              activeIcon: Icon(Icons.home_rounded, size: 26),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded, size: 24),
              activeIcon: Icon(Icons.account_balance_wallet_rounded, size: 26),
              label: 'Accounts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_rounded, size: 24),
              activeIcon: Icon(Icons.confirmation_number_rounded, size: 26),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 24),
              activeIcon: Icon(Icons.person_rounded, size: 26),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
