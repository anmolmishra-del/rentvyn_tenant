import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/notices/cubit/notice_cubit.dart';
import 'package:rentvyn_tenant/features/notices/models/notice_model.dart';
import 'package:rentvyn_tenant/features/notices/state/notice_state.dart';

class NoticeCarousel extends StatefulWidget {
  const NoticeCarousel({super.key});

  @override
  State<NoticeCarousel> createState() => _NoticeCarouselState();
}

class _NoticeCarouselState extends State<NoticeCarousel>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentPage = 0;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatNoticeDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM, hh:mm a').format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }

  String _formatEventRange(String? fromStr, String? toStr) {
    if (fromStr == null || fromStr.isEmpty) return '';
    try {
      final fromDateTime = DateTime.parse(fromStr).toLocal();
      final fromFormatted = DateFormat('dd MMM, hh:mm a').format(fromDateTime);
      if (toStr != null && toStr.isNotEmpty) {
        final toDateTime = DateTime.parse(toStr).toLocal();
        final toFormatted = DateFormat('hh:mm a').format(toDateTime);
        if (fromDateTime.year == toDateTime.year &&
            fromDateTime.month == toDateTime.month &&
            fromDateTime.day == toDateTime.day) {
          return "$fromFormatted - $toFormatted";
        } else {
          return "$fromFormatted - ${DateFormat('dd MMM, hh:mm a').format(toDateTime)}";
        }
      }
      return fromFormatted;
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeCubit, NoticeState>(
      builder: (context, state) {
        if (state.loading) {
          if (state.notices.isNotEmpty) {
            return _buildLoadingSkeleton();
          } else {
            return const SizedBox.shrink();
          }
        }

        if (state.error != null || state.notices.isEmpty) {
          return const SizedBox.shrink();
        }

        final notices = state.notices;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.2).animate(
                      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                    ),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "PG Notices & Updates",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  if (notices.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${_currentPage + 1}/${notices.length}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: PageView.builder(
                controller: _pageController,
                itemCount: notices.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final notice = notices[index];
                  return _buildNoticeCard(context, notice);
                },
              ),
            ),
            if (notices.length > 1) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  notices.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    height: 5.0,
                    width: _currentPage == index ? 18.0 : 6.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildNoticeCard(BuildContext context, NoticeModel notice) {
    final titleLower = (notice.title ?? '').toLowerCase();
    final descLower = (notice.description).toLowerCase();

    Color bgColor;
    Color iconColor;
    Color textColor;
    IconData iconData;
    String badgeText;
    List<Color> gradientColors;

    if (titleLower.contains('urgent') ||
        titleLower.contains('alert') ||
        titleLower.contains('warning') ||
        descLower.contains('urgent')) {
      bgColor = const Color(0xFFFFF1F2);
      iconColor = const Color(0xFFE11D48);
      textColor = const Color(0xFF9F1239);
      iconData = Icons.campaign_rounded;
      badgeText = "Urgent";
      gradientColors = [const Color(0xFFFFF1F2), const Color(0xFFFFE4E6)];
    } else if (titleLower.contains('maintenance') ||
        titleLower.contains('repair') ||
        titleLower.contains('service') ||
        titleLower.contains('wifi') ||
        titleLower.contains('wi-fi') ||
        descLower.contains('maintenance')) {
      bgColor = const Color(0xFFEFF6FF);
      iconColor = const Color(0xFF2563EB);
      textColor = const Color(0xFF1E40AF);
      iconData = Icons.construction_rounded;
      badgeText = "Maintenance";
      gradientColors = [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)];
    } else {
      bgColor = const Color(0xFFFAF5FF);
      iconColor = const Color(0xFF9333EA);
      textColor = const Color(0xFF6B21A8);
      iconData = Icons.notifications_active_rounded;
      badgeText = "Announcement";
      gradientColors = [const Color(0xFFFDF4FF), const Color(0xFFFAE8FF)];
    }

    final eventRange = _formatEventRange(notice.fromDate, notice.toDate);

    return GestureDetector(
      onTap: () => _showNoticeDetailsSheet(
        context,
        notice,
        bgColor,
        iconColor,
        textColor,
        iconData,
        badgeText,
        gradientColors,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: iconColor.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -15,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withOpacity(0.03),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              badgeText.toUpperCase(),
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _formatNoticeDate(notice.createdAt ?? ''),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: textColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notice.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notice.description,
                        maxLines: eventRange.isNotEmpty ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: textColor.withOpacity(0.8),
                          height: 1.3,
                        ),
                      ),
                      if (eventRange.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.event_rounded,
                              size: 11,
                              color: textColor.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                eventRange,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: textColor.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: textColor.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 180,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 130,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: const Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showNoticeDetailsSheet(
    BuildContext context,
    NoticeModel notice,
    Color bgColor,
    Color iconColor,
    Color textColor,
    IconData iconData,
    String badgeText,
    List<Color> gradientColors,
  ) {
    final eventRange = _formatEventRange(notice.fromDate, notice.toDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32.0),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 10.0,
                  bottom: MediaQuery.of(context).padding.bottom + 24.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: iconColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              iconData,
                              color: iconColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  badgeText.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatNoticeDate(notice.createdAt ?? ''),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      notice.title ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    if (eventRange.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              color: iconColor,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Event / Maintenance Schedule",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  eventRange,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 18),
                    const Divider(height: 1),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Text(
                        notice.description,
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[900],
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          "Acknowledge & Close",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
