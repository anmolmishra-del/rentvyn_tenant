import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/tickets/views/ticket_raise.dart';
import 'home_tab.dart';
import 'accounts_tab.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: tabs,
      ),
     bottomNavigationBar: SafeArea(
  top: false,
  child: SizedBox(
    height: 80,
    child: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 30,
          sigmaY: 20,
        ),
        child: CurvedNavigationBar(
          index: _selectedIndex,
          height: 68,
          backgroundColor: Colors.transparent,
          color: AppColors.primary,
          buttonBackgroundColor: AppColors.primary,
          animationDuration: const Duration(milliseconds: 350),
          items: [
            Icon(
              Icons.home_rounded,
              size: 26,
              color: Colors.white,
            ),
            Icon(
              Icons.account_balance_wallet_rounded,
              size: 26,
              color: Colors.white,
            ),
            Icon(
              Icons.confirmation_number_rounded,
              size: 26,
              color: Colors.white,
            ),
            Icon(
              Icons.person_rounded,
              size: 26,
              color: Colors.white,
            ),
          ],
          onTap: (index) async {
            await Future.delayed(
              const Duration(milliseconds: 350),
            );

            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    ),
  ),

      ),
    );
  }
}
