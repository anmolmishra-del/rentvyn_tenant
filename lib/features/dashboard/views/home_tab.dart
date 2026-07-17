import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';
import 'package:rentvyn_tenant/features/payments/services/razorpay_service.dart';
import 'package:rentvyn_tenant/features/payments/cubit/pg_contact_cubit.dart';
import 'package:rentvyn_tenant/features/auth/cubit/login_cubit.dart';
import 'package:rentvyn_tenant/features/auth/state/login_state.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/auth/models/owner_model.dart';
import 'package:intl/intl.dart';
import 'package:rentvyn_tenant/features/notices/cubit/notice_cubit.dart';
import 'package:rentvyn_tenant/features/notices/views/notice_carousel.dart';
import 'package:rentvyn_tenant/features/payments/cubit/bills_cubit.dart';
import 'package:rentvyn_tenant/features/payments/state/bills_state.dart';
import 'package:rentvyn_tenant/features/payments/models/bill_model.dart';
import 'package:rentvyn_tenant/features/payments/views/payment_status_dialog.dart';
import 'package:rentvyn_tenant/l10n/app_localizations.dart';

import '../../auth/cubit/auth_service.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<void> _handleRefresh(BuildContext context) async {
    try {
      await context.read<LoginCubit>().loadUser();
      context.read<NoticeCubit>().loadNotices();
      context.read<PgContactCubit>().loadPgContact();
      context.read<BillsCubit>().loadBills();
    } catch (e) {
      print("Error loading data in home_tab: $e");
    }
  }


  void _openRazorpayCheckoutForBill(BuildContext context, Owner? owner, BillModel bill) async {
    if (owner == null) return;

    // Show loading spinner
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      },
    );

    // Call the Create Order API on backend
    final orderResponse = await AuthService.createOrder(amount: bill.amount, billId: bill.id);

    // Close loading spinner
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    if (orderResponse == null || orderResponse['order_id'] == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to initialize transaction order. Try again.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final String orderId = orderResponse['order_id'];
    final double finalAmount = (orderResponse['amount'] != null)
        ? (orderResponse['amount'] is num ? (orderResponse['amount'] as num).toDouble() / 100 : bill.amount)
        : bill.amount;

    final phone = owner.phoneNumber ?? '';
    final email = owner.email ?? '';
    final name = owner.name ?? '';

    if (context.mounted) {
      RazorpayService().openCheckout(
        amount: finalAmount,
        name: 'Rentvyn PG Services',
        description: 'Payment for Bill: ${bill.billNumber}',
        phone: phone,
        email: email,
        orderId: orderId,
        
        onSuccess: (response) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return PaymentStatusDialog(
                billId: bill.id.toString(),
                billNumber: bill.billNumber,
                amount: finalAmount,
                paymentId: response.paymentId ?? '',
                orderId: orderId,
                signature: response.signature ?? '',
                onSuccess: () {
                  // Refresh bills state upon success
                  context.read<BillsCubit>().loadBills();
                },
              );
            },
          );
        },
        onFailure: (response) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment Failed: ${response.message}'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';

    try {
      return DateFormat('dd').format(DateTime.parse(dateString));
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, loginState) {
        final owner = loginState.owner;

        if (loginState.isLoading && owner == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        final theme = Theme.of(context);
        final language = AppLocalizations.of(context)!;
        final firstName = owner?.firstName ?? 'Tenant';
        final rent = owner?.rent ?? 0;
        final formattedRent = '₹${rent.toStringAsFixed(0)}';
        final formattedDeposit = owner?.formattedDeposit ?? '—';
        final roomId = owner?.roomId?.toString() ?? '—';
        final hostelName = owner?.hostelName ?? '';

        print("HOME HOSTEL NAME => $hostelName");
        print("TENANT => ${owner?.toJson()}");
        final verified = owner?.identityVerified ?? false;
        final active = owner?.active ?? false;
        final joinedDate = owner?.joinDate ?? '';

        // Compute initials for avatar
        final name = owner?.name ?? '';
        final initials = name.trim().isEmpty
            ? 'T'
            : name.trim().split(' ').map((e) => e[0].toUpperCase()).take(2).join();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Rentvyn Tenant',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.primary,
                letterSpacing: -0.5,
              ),
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.18 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded,
                      color: AppColors.primary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No new notifications'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => _handleRefresh(context),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Welcome header ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            language.welcomeBack,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$firstName 👋',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      // Avatar
                      CircleAvatar(
                        radius: 26,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Notices / Announcements Carousel
                  const NoticeCarousel(),
                  const SizedBox(height: 24),

                  // ── Total Dues Card ───────────────────────────────────
                  BlocBuilder<BillsCubit, BillsState>(
                    builder: (context, billsState) {
                      final activeBill = billsState.activePendingBill;
                      final hasPendingBill = activeBill != null;

                      final billAmount = hasPendingBill ? activeBill.amount : 0.0;
                      final billNumber = hasPendingBill ? activeBill.billNumber : 'No outstanding bills';
                      final displayAmount = '₹${billAmount.toStringAsFixed(0)}';

                      String displayDueDate = '—';
                      if (hasPendingBill && activeBill.dueDate.isNotEmpty) {
                        try {
                          final dt = DateTime.parse(activeBill.dueDate);
                          displayDueDate = DateFormat('dd MMM yyyy').format(dt);
                        } catch (_) {
                          displayDueDate = activeBill.dueDate;
                        }
                      }

                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    hasPendingBill ? 'BILL NO: $billNumber' : 'MONTHLY BILL DUE',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.receipt_long_rounded,
                                      color: Colors.white, size: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              displayAmount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.calendar_today_rounded,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.7)),
                                const SizedBox(width: 6),
                                Text(
                                  hasPendingBill
                                      ? '${language.dueOn} $displayDueDate'
                                      : 'No pending payment dues',
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hostelName.isNotEmpty
                                              ? hostelName
                                              : language.rentvynPg,
                                          style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.9),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          roomId != '—'
                                              ? '${language.room} $roomId'
                                              : '${language.room} —',
                                          style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.7),
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (hasPendingBill)
                                    ElevatedButton(
                                      onPressed: () => _openRazorpayCheckoutForBill(context, owner, activeBill),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: AppColors.primary,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        language.payNow,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Paid',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Quick stats row ───────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          label: language.securityDeposit,
                          value: formattedDeposit,
                          icon: Icons.shield_rounded,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          label: language.roomNumber,
                          value: roomId != '—'
                              ? '${language.room} $roomId'
                              : '—',
                          icon: Icons.bed_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Auto-Pay Banner ───────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.18 : 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.7)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFECEF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.secondary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                language.introducingAutoPay,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                language.autoPayDescription,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Profile & Stay Overview ───────────────────────────
                  Text(
                    language.profileStayOverview,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildStatusItem(
                    context,
                    icon: Icons.gpp_good_rounded,
                    iconColor: verified ? Colors.teal : Colors.orange,
                    backgroundColor: verified
                        ? const Color(0xFFE0F2F1)
                        : const Color(0xFFFFF3E0),
                    title: language.identityVerification,
                    subtitle: verified
                        ? language.identityVerifiedMessage
                        : language.identityPendingMessage,
                    statusText: verified ? language.verified : language.pending,
                    statusColor: verified ? Colors.teal : Colors.orange,
                    statusBg: verified
                        ? const Color(0xFFE0F2F1)
                        : const Color(0xFFFFF3E0),
                  ),
                  const SizedBox(height: 12),

                  _buildStatusItem(
                    context,
                    icon: Icons.holiday_village_rounded,
                    iconColor: active ? AppColors.primary : Colors.red,
                    backgroundColor: active
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    title: language.stayStatus,
                    subtitle: active
                        ? language.activeStayMessage
                        : language.inactiveStayMessage,
                    statusText: active ? language.activeStay : language.inactive,
                    statusColor: active ? AppColors.primary : Colors.red,
                    statusBg: active
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.18 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required String statusText,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.18 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
