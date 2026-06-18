import 'package:flutter/material.dart';
import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/auth/models/owner_model.dart';
import 'package:rentvyn_tenant/features/dashboard/views/agreement_details_page.dart';
import 'package:rentvyn_tenant/features/dashboard/views/verification_details_page.dart';
import 'package:rentvyn_tenant/features/dashboard/views/roommate_details_page.dart';

class ProfileTab extends StatefulWidget {
  final VoidCallback? onLogout;
  const ProfileTab({super.key, this.onLogout});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            tooltip: 'Log Out',
            onPressed: widget.onLogout,
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadOwner,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 20),
                    _buildPersonalDetailsCard(),
                    const SizedBox(height: 16),
                    _buildRoomDetailsCard(),
                    const SizedBox(height: 16),
                    _buildEmergencyContactCard(),
                    const SizedBox(height: 16),
                    _buildMenuOptionsCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  // ── Profile header ─────────────────────────────────────────────────────────
  Widget _buildProfileHeader() {
    final name = _owner?.name ?? 'Tenant';
    final email = _owner?.email ?? '';
    final initials = name.trim().isEmpty
        ? 'T'
        : name.trim().split(' ').map((e) => e[0].toUpperCase()).take(2).join();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 46,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: _owner?.photoUrl != null
                    ? ClipOval(
                        child: Image.network(
                          _owner!.photoUrl!,
                          width: 92,
                          height: 92,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _owner?.identityVerified == true
                        ? Colors.green
                        : Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    _owner?.identityVerified == true
                        ? Icons.verified_rounded
                        : Icons.pending_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
          const SizedBox(height: 12),
          // Status badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(
                label: _owner?.active == true ? 'Active' : 'Inactive',
                color: _owner?.active == true ? Colors.green : Colors.red,
                icon: Icons.circle,
              ),
              const SizedBox(width: 10),
              _buildBadge(
                label: _owner?.identityVerified == true
                    ? 'Verified'
                    : 'Unverified',
                color: _owner?.identityVerified == true
                    ? AppColors.primary
                    : Colors.orange,
                icon: _owner?.identityVerified == true
                    ? Icons.verified_rounded
                    : Icons.warning_amber_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(
      {required String label, required Color color, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ── Personal details ───────────────────────────────────────────────────────
  Widget _buildPersonalDetailsCard() {
    final gender = _owner?.gender ?? '';
    final phone = _owner?.phoneNumber ?? '';
    final altPhone = _owner?.alternatePhoneNumber ?? '';

    return _buildCard(
      icon: Icons.person_outline_rounded,
      title: 'Personal Details',
      children: [
        _row('Phone', phone.isNotEmpty ? '+91 $phone' : '—'),
        if (altPhone.isNotEmpty) ...[
          const Divider(height: 24),
          _row('Alt. Phone', '+91 $altPhone'),
        ],
        const Divider(height: 24),
        _row('Gender', _capitalize(gender)),
        const Divider(height: 24),
        _row('Address', _owner?.address ?? '—'),
        const Divider(height: 24),
        _row(
            'City / State',
            [_owner?.city, _owner?.state]
                .where((e) => e != null && e.isNotEmpty)
                .join(', ')),
        const Divider(height: 24),
        _row('Zipcode', _owner?.zipcode ?? '—'),
      ],
    );
  }

  // ── Room details ────────────────────────────────────────────────────────────
  Widget _buildRoomDetailsCard() {
    final joinDate = _formatDate(_owner?.joinDate ?? '');
    return _buildCard(
      icon: Icons.bed_rounded,
      title: 'Room & Rent Details',
      children: [
        _row('Room No', _owner?.roomId?.toString() ?? '—'),
        const Divider(height: 24),
        // _row('Hostel ID', _owner?.hostelId.toString() ?? '—'),
        // const Divider(height: 24),
        _row('Monthly Rent', _owner?.formattedRent ?? '—'),
        const Divider(height: 24),
        _row('Security Deposit', _owner?.formattedDeposit ?? '—'),
        const Divider(height: 24),
        _row('Join Date', joinDate.isNotEmpty ? joinDate : '—'),
      ],
    );
  }

  // ── Emergency contact ───────────────────────────────────────────────────────
  Widget _buildEmergencyContactCard() {
    return _buildCard(
      icon: Icons.emergency_rounded,
      title: 'Emergency Contact',
      children: [
        _row('Name', _owner?.emergencyContactName ?? '—'),
        const Divider(height: 24),
        _row('Phone', _owner?.emergencyContactPhone ?? '—'),
        const Divider(height: 24),
        _row('Relationship',
            _capitalize(_owner?.emergencyContactRelationship ?? '')),
      ],
    );
  }

  // ── Navigation menu cards ───────────────────────────────────────────────────
  Widget _buildMenuOptionsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F1F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.assignment_outlined,
            title: 'Rental Agreement',
            subtitle: 'ID, monthly rent, download PDF',
            destination: const AgreementDetailsPage(),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.gpp_good_outlined,
            title: 'Police Verification (BG Check)',
            subtitle: 'e-KYC verification status & details',
            destination: const VerificationDetailsPage(),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.people_outline_rounded,
            title: 'Roommate Details',
            subtitle: 'Occupants in your room',
            destination: const RoommateDetailsPage(),
          ),
        ],
      ),
    );
  }

  // ── Shared helpers ──────────────────────────────────────────────────────────
  Widget _buildCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F1F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value.isNotEmpty ? value : '—',
            textAlign: TextAlign.end,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget destination,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a, __) => destination,
            transitionsBuilder: (_, a, __, child) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: a, curve: Curves.fastOutSlowIn)),
              child: child,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? '—' : s[0].toUpperCase() + s.substring(1);

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
