
import 'package:flutter/material.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';

class AccountsTab extends StatelessWidget {
  const AccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Premium off-white fintech surface
      appBar: AppBar(
        title: const Text(
          'My Accounts',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cashback balance wallet banner
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  )
                ],
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED), // Cream/Amber hue
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.amber, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CASHBACK BALANCE',
                          style: TextStyle(
                            color: Colors.grey[500], 
                            fontSize: 11, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '₹350.00',
                          style: TextStyle(
                            fontSize: 28, 
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Redeem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Cashbacks details / Scratchcards section
            Text(
              'Cashback Rewards',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildScratchCard(context, 'Rent Paid Reward', 'Core Reward', '₹200', true),
                const SizedBox(width: 16),
                _buildScratchCard(context, 'Onboarding Bonus', 'Welcome Gift', 'Locked', false),
              ],
            ),
            const SizedBox(height: 32),

            // Active Invoice / Dues
            Text(
              'Outstanding & Active Bills',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildDueItem('Monthly Room Rent', '₹4,500.00', 'Due in 20 days', true),
                const SizedBox(height: 12),
                _buildDueItem('Electricity Bill', '₹650.00', 'Paid on Jun 05, 2026', false),
                const SizedBox(height: 12),
                _buildDueItem('Maintenance Fee', '₹1,000.00', 'Paid on Jun 05, 2026', false),
              ],
            ),
            const SizedBox(height: 32),

            // Expenses tracker section
            Text(
              'Monthly Expense Distribution',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                children: [
                  _buildExpenseBar('Room Rent', 0.75, '₹14,500', AppColors.primary),
                  const SizedBox(height: 20),
                  _buildExpenseBar('Food & Meals', 0.15, '₹3,000', AppColors.secondary),
                  const SizedBox(height: 20),
                  _buildExpenseBar('Amenities & Electricity', 0.10, '₹1,650', Colors.teal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScratchCard(BuildContext context, String title, String subtitle, String value, bool isUnlocked) {
    return Expanded(
      child: Container(
        height: 125,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isUnlocked 
              ? const LinearGradient(
                  colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isUnlocked ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle, 
                  style: TextStyle(fontSize: 10, color: isUnlocked ? Colors.amber[900] : Colors.grey[500]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: isUnlocked ? const Color(0xFFB45309) : Colors.grey[400],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isUnlocked ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isUnlocked ? Icons.card_giftcard_rounded : Icons.lock_outline_rounded,
                    color: isUnlocked ? const Color(0xFFD97706) : Colors.grey[500],
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDueItem(String title, String amount, String status, bool isOutstanding) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          // Vertical visual indicator accent
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: isOutstanding ? Colors.orange : Colors.teal,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(
                  status, 
                  style: TextStyle(
                    color: isOutstanding ? const Color(0xFFEA580C) : Colors.grey[500],
                    fontSize: 12,
                    fontWeight: isOutstanding ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount, 
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.black87, letterSpacing: -0.3),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOutstanding ? const Color(0xFFFFF3EA) : const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isOutstanding ? 'Unpaid' : 'Paid',
                  style: TextStyle(
                    color: isOutstanding ? const Color(0xFFEA580C) : Colors.teal,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBar(String label, double percentage, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

