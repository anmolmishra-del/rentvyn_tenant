import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/auth/models/owner_model.dart';
import 'package:intl/intl.dart';
import 'package:rentvyn_tenant/features/notices/cubit/notice_cubit.dart';
import 'package:rentvyn_tenant/features/notices/views/notice_carousel.dart';
import 'package:rentvyn_tenant/l10n/app_localizations.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Owner? _owner;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOwner();
  }

  Future<void> _loadOwner() async {
    final owner = await AuthStorage.getOwner();
    if (mounted) {
      setState(() {
        _owner = owner;
        _loading = false;
      });
      try {
        context.read<NoticeCubit>().loadNotices();
      } catch (e) {
        print("Error loading notices in home_tab: $e");
      }
    }
  }
  String formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) return '-';

  try {
    return DateFormat('dd')
        .format(DateTime.parse(dateString));
  } catch (e) {
    return '-';
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  final language = AppLocalizations.of(context)!;
    final firstName = _owner?.firstName ?? 'Tenant';
    final rent = _owner?.rent ?? 0;
    final formattedRent = '₹${rent.toStringAsFixed(0)}';
    final formattedDeposit = _owner?.formattedDeposit ?? '—';
    final roomId = _owner?.roomId?.toString() ?? '—';
    final city = _owner?.city ?? '';
    final verified = _owner?.identityVerified ?? false;
    final active = _owner?.active ?? false;
    final joinedDate=_owner?.joinDate ?? '';

    // Compute initials for avatar
    final name = _owner?.name ?? '';
    final initials = name.trim().isEmpty
        ? 'T'
        : name.trim().split(' ').map((e) => e[0].toUpperCase()).take(2).join();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Rentvyn Tenant',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
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
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadOwner,
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
 language.welcomeBack,                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$firstName 👋',
                              style:
                                  theme.textTheme.headlineSmall?.copyWith(
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

                    // ── Total Dues Card ───────────────────────────────────
                    Container(
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
                              Text(
                                // 'MONTHLY RENT DUE',
                                language.monthlyRentDue,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 11,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.receipt_long_rounded,
                                    color: Colors.white, size: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            formattedRent,
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
                                  color:
                                      Colors.white.withValues(alpha: 0.7)),
                              const SizedBox(width: 6),
                              Text(
                                  '${language.dueOn} ${formatDate(joinedDate)} ${language.everyMonth}',

                                // 'Due on ${formatDate(joinedDate)} of every month',
                                style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.8),
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // city.isNotEmpty
                                        //     ? city
                                        //     : 'Rentvyn PG',
                                        city.isNotEmpty
    ? city
    : language.rentvynPg,
                                        style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.9),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        roomId != '—'
    ? '${language.room} $roomId'
    : '${language.room} —',
                                        // roomId != '—'
                                        //     ? 'Room $roomId'
                                        //     : 'Room —',
                                        style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.7),
                                            fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
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
                                  child:  Text(
                                    // 'Pay Now',
                                    language.payNow,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Quick stats row ───────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 
                            // 'Security Deposit',
                            language.securityDeposit,
                            value: formattedDeposit,
                            icon: Icons.shield_rounded,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            label: 
                            // 'Room No.',
                            language.roomNumber,
                            value: roomId != '—'
    ? '${language.room} $roomId'
    : '—',
                            // value: roomId != '—' ? 'Room $roomId' : '—',
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                        border: Border.all(color: Colors.grey[100]!),
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
                                  // 'Introducing Auto-Pay! 🚀',
                                    language.introducingAutoPay,

                                  style:
                                      theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  language.autoPayDescription,
                                  // 'Link UPI/Card for automatic monthly rent & double cashback rewards.',
                                  style: TextStyle(
                                    color: Colors.grey[600],
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

                      // 'Profile & Stay Overview',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildStatusItem(
                      icon: Icons.gpp_good_rounded,
                      iconColor:
                          verified ? Colors.teal : Colors.orange,
                      backgroundColor: verified
                          ? const Color(0xFFE0F2F1)
                          : const Color(0xFFFFF3E0),
                      // title: 'Identity Verification',
                      title: language.identityVerification,
                      subtitle: verified
    ? language.identityVerifiedMessage
    : language.identityPendingMessage,
                      // subtitle: verified
                      //     ? 'Your identity has been verified successfully.'
                      //     : 'Your identity verification is pending.',
                      // statusText: verified ? 'Verified' : 'Pending',
                      statusText: verified
    ? language.verified
    : language.pending,
                      statusColor:
                          verified ? Colors.teal : Colors.orange,
                      statusBg: verified
                          ? const Color(0xFFE0F2F1)
                          : const Color(0xFFFFF3E0),
                    ),
                    const SizedBox(height: 12),

                    _buildStatusItem(
                      icon: Icons.holiday_village_rounded,
                      iconColor: active ? AppColors.primary : Colors.red,
                      backgroundColor: active
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      // title: 'Stay Status',
                      title: language.stayStatus,
                      subtitle: active
    ? language.activeStayMessage
    : language.inactiveStayMessage,
                      // subtitle: active
                      //     ? 'Active contract. No notice period raised.'
                      //     : 'Your stay is currently inactive.',
                      // statusText: active ? 'Active Stay' : 'Inactive',
                      statusText: active
    ? language.activeStay
    : language.inactive,
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
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
              color: Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
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
