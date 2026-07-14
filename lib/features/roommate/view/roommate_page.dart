import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/roommate/cubit/roommate_cubit.dart';
import 'package:rentvyn_tenant/features/roommate/state/state.dart';

class RoommateDetailsPage extends StatelessWidget {
  final int roomId;
  final int currentTenantId;

  const RoommateDetailsPage({
    super.key,
    required this.roomId,
    required this.currentTenantId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => RoommateCubit()..loadRoommates(roomId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Roommates'),
          centerTitle: true,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocBuilder<RoommateCubit, RoommateState>(
          builder: (context, state) {
            if (state is RoommateLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            }

            if (state is RoommateError) {
              return _buildStatusMessage(
                context,
                icon: Icons.error_outline,
                title: 'Unable to load roommates',
                message: state.message,
                color: theme.colorScheme.error,
              );
            }

            if (state is RoommateLoaded) {
              final roommates = state.roommates
                  .where((e) => e.id != currentTenantId)
                  .toList();

              if (roommates.isEmpty) {
                return _buildStatusMessage(
                  context,
                  icon: Icons.group_off_outlined,
                  title: 'No roommates found',
                  message: 'Looks like you are currently alone in this room.',
                );
              }

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                children: [
                  _buildHeaderCard(context, roommates.length),
                  const SizedBox(height: 18),
                  ...roommates.map((roommate) => _buildRoommateCard(context, roommate)).toList(),
                  const SizedBox(height: 18),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, int count) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.group_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room $roomId',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$count roommates',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Quickly view contact details and room assignment for everyone sharing this space.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoommateCard(BuildContext context, dynamic roommate) {
    final theme = Theme.of(context);
    final initials = _getInitials(roommate.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: Text(
                    initials,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roommate.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        roommate.email,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionButton(
                  icon: Icons.call,
                  label: 'Call',
                  onTap: () {},
                  context: context,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(
                  context,
                  icon: Icons.phone_iphone,
                  label: roommate.phoneNumber,
                ),
                const SizedBox(width: 10),
                _buildInfoChip(
                  context,
                  icon: Icons.meeting_room,
                  label: 'Room ${roommate.roomNumber}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context,
      {required IconData icon, required String label}) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.14),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMessage(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: effectiveColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 42, color: effectiveColor),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
