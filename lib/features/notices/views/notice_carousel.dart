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

class _NoticeCarouselState extends State<NoticeCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.93);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeCubit, NoticeState>(
      builder: (context, state) {
        if (state.loading) {
          return _buildLoadingSkeleton();
        }

        if (state.error != null) {
          // Silent failure or small error widget so it doesn't break the home screen
          return const SizedBox.shrink();
        }

        if (state.notices.isEmpty) {
          return const SizedBox.shrink();
        }

        final notices = state.notices;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Announcements & Notices",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (notices.length > 1)
                    Text(
                      "${_currentPage + 1}/${notices.length}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 125,
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
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  notices.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    height: 5.0,
                    width: _currentPage == index ? 16.0 : 6.0,
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

  Widget _buildNoticeCard(BuildContext context, Notice notice) {
    Color bgColor;
    Color iconColor;
    Color textColor;
    IconData iconData;
    String badgeText;

    switch (notice.type.toLowerCase()) {
      case 'urgent':
        bgColor = const Color(0xFFFFF1F2); // Soft rose
        iconColor = const Color(0xFFE11D48); // Deep rose
        textColor = const Color(0xFF9F1239);
        iconData = Icons.campaign_rounded;
        badgeText = "Urgent";
        break;
      case 'maintenance':
        bgColor = const Color(0xFFEFF6FF); // Soft blue
        iconColor = const Color(0xFF2563EB); // Vibrant blue
        textColor = const Color(0xFF1E40AF);
        iconData = Icons.construction_rounded;
        badgeText = "Maintenance";
        break;
      case 'info':
      default:
        bgColor = const Color(0xFFFDF4FF); // Soft violet
        iconColor = const Color(0xFF9333EA); // Vibrant purple
        textColor = const Color(0xFF6B21A8);
        iconData = Icons.notifications_active_rounded;
        badgeText = "Info";
        break;
    }

    return GestureDetector(
      onTap: () => _showNoticeDetailsSheet(context, notice, bgColor, iconColor, textColor, iconData, badgeText),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: iconColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Icon Badge
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
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
            // Middle Content
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
                          color: iconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          badgeText.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.0,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        _formatNoticeDate(notice.createdAt),
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                          color: textColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notice.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notice.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: textColor.withValues(alpha: 0.8),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
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
        Container(
          width: 180,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 125,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
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
    Notice notice,
    Color bgColor,
    Color iconColor,
    Color textColor,
    IconData iconData,
    String badgeText,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.0),
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
                  top: 8.0,
                  bottom: MediaQuery.of(context).padding.bottom + 24.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Header Row (Icon + Badge)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            iconData,
                            color: iconColor,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: iconColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                badgeText.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatNoticeDate(notice.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      notice.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    // Content body
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Text(
                        notice.content,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Dismiss Button
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
                            borderRadius: BorderRadius.circular(16),
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
