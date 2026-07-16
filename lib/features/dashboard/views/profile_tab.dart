import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/core/theme/theme_provider.dart';
import 'package:rentvyn_tenant/features/agreement_details_page/view/rental_agremeent_page.dart';
import 'package:rentvyn_tenant/features/auth/models/owner_model.dart';
import 'package:rentvyn_tenant/features/dashboard/views/verification_details_page.dart';
import 'package:rentvyn_tenant/features/language/view/language_page.dart';
import 'package:rentvyn_tenant/features/roommate/view/roommate_page.dart';
import 'package:rentvyn_tenant/l10n/app_localizations.dart';

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
        //_owner = await AuthStrorage.geOwner();
             //if(mounted){
            //setState(()){
           //_owner = owner;
          //_loading = false;
         //  }
        // }
       
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    print("Rental Agreement URL => ${_owner?.rentalAgreement}");
      final language = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(language.myProfile,
            style: TextStyle(fontWeight: FontWeight.bold, )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            // tooltip: 'Log Out',
            tooltip: language.logOut,
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

// _buildMenuItem(
//   context,
//   icon: Icons.language,
//   title: 'Language',
//   subtitle:
//       'English / Telugu / Hindi',
//   destination:
//       const LanguagePage(),
// ),
                  ],
                ),
              ),
            ),
    );
  }

  // ── Profile header ─────────────────────────────────────────────────────────
  Widget _buildProfileHeader() {
      final language = AppLocalizations.of(context)!;
    final name = _owner?.name ?? 'Tenant';
    final email = _owner?.email ?? '';
    final initials = name.trim().isEmpty
        ? 'T'
        : name.trim().split(' ').map((e) => e[0].toUpperCase()).take(2).join();

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.2 : 0.04),
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
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
          const SizedBox(height: 12),
          // Status badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(
                label: _owner?.active == true
    ? language.active
    : language.inactive,
                // label: _owner?.active == true ? 'Active' : 'Inactive',
                color: _owner?.active == true ? Colors.green : Colors.red,
                icon: Icons.circle,
              ),
              const SizedBox(width: 10),
              _buildBadge(
                // label: _owner?.identityVerified == true
                //     ? 'Verified'
                //     : 'Unverified',
                label: _owner?.identityVerified == true
    ? language.verified
    : language.unverified,
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
      final language = AppLocalizations.of(context)!;
    final gender = _owner?.gender ?? '';
    final phone = _owner?.phoneNumber ?? '';
    final altPhone = _owner?.alternatePhoneNumber ?? '';

    return _buildCard(
      icon: Icons.person_outline_rounded,
      // title: 'Personal Details',
      title: language.personalDetails,
      children: [
        _row(language.phone, phone.isNotEmpty ? '+91 $phone' : '—'),
        if (altPhone.isNotEmpty) ...[
          const Divider(height: 24),
          _row(language.altPhone, '+91 $altPhone'),
        ],
        const Divider(height: 24),
        _row(language.gender, _capitalize(gender)),
        const Divider(height: 24),
        _row(language.address, _owner?.address ?? '—'),
        const Divider(height: 24),
        _row(
            language.cityState,
            [_owner?.city, _owner?.state]
                .where((e) => e != null && e.isNotEmpty)
                .join(', ')),
        const Divider(height: 24),
        _row(language.zipcode, _owner?.zipcode ?? '—'),
      ],
    );
  }

  // ── Room details ────────────────────────────────────────────────────────────
  Widget _buildRoomDetailsCard() {
      final language = AppLocalizations.of(context)!;
    final joinDate = _formatDate(_owner?.joinDate ?? '');
    return _buildCard(
      icon: Icons.bed_rounded,
      // title: 'Room & Rent Details',
      title: language.roomRentDetails,
      children: [
        _row(language.roomNo, _owner?.roomId?.toString() ?? '—'),
        const Divider(height: 24),
        // _row('Hostel ID', _owner?.hostelId.toString() ?? '—'),
        // const Divider(height: 24),
        _row(language.monthlyRent, _owner?.formattedRent ?? '—'),
        const Divider(height: 24),
        _row(language.securityDeposit, _owner?.formattedDeposit ?? '—'),
        const Divider(height: 24),
        _row(language.joinDate, joinDate.isNotEmpty ? joinDate : '—'),
      ],
    );
  }

  // ── Emergency contact ───────────────────────────────────────────────────────
  Widget _buildEmergencyContactCard() {
     final language = AppLocalizations.of(context)!;
    return _buildCard(
      icon: Icons.emergency_rounded,
      title: language.emergencyContact,
      children: [
        _row(language.name, _owner?.emergencyContactName ?? '—'),
        const Divider(height: 24),
        _row(language.phone, _owner?.emergencyContactPhone ?? '—'),
        const Divider(height: 24),
        _row(language.relationship,
            _capitalize(_owner?.emergencyContactRelationship ?? '')),
      ],
    );
  }

  Widget _buildMenuOptionsCard() {
      final language = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
//           _buildMenuItem(
//             context,
//             icon: Icons.assignment_outlined,
//             title: language.rentalAgreement,
// subtitle: language.rentalAgreementSubtitle,
//             // title: 'Rental Agreement',
//             // subtitle: 'ID, monthly rent, download PDF',
//             destination: const AgreementDetailsPage(),
//           ),
if (_owner?.isAgreement == false) ...[
  _buildMenuItem(
    context,
    icon: Icons.assignment_outlined,
    title: language.rentalAgreement,
    subtitle: language.rentalAgreementSubtitle,
    // destination: const AgreementDetailsPage(pdfUrl: '',),
  destination: RentalAgreementPage(
  tenantId: 56,
  token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3ODQ3OTMwMDQsInN1YiI6Ijk5NjYyNjcxNzgiLCJpYXQiOjE3ODIyMDEwMDQsIm93bmVyX2lkIjo2fQ.XXFhgUJy0eNvEtRaVWNkQImtyQHL33H_5WQYzOwtC5g"
),
  


  ),
  const Divider(height: 1),
],
          const Divider(height: 1),
          _buildMenuItem(
            context,
            icon: Icons.gpp_good_outlined,
            title: language.policeVerification,
subtitle: language.policeVerificationSubtitle,
 onTap: () {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Why background verification is necessary?",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Well, we know you're for real. But for security purposes, law of the land requires us to conduct your police verification.\n\n"
          "With RentVyn, you don't need to go to the Police Station.\n\n"
          "Just fill all your profile details, and your verification will be processed.",
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  },
            // title: 'Police Verification (BG Check)',
            // subtitle: 'e-KYC verification status & details',
            destination: const VerificationDetailsPage(),
          ),
// if ((_owner?.policeVerification ?? '').isNotEmpty) ...[
//   _buildMenuItem(
//     context,
//     icon: Icons.gpp_good_outlined,
//     title: language.policeVerification,
//     subtitle: language.policeVerificationSubtitle,
//     destination: const VerificationDetailsPage(),
//   ),
//   const Divider(height: 1),
// ],
          const Divider(height: 1),
_buildMenuItem(
  context,
  icon: Icons.people_outline_rounded,
  title: language.roommateDetails,
  subtitle: language.roommateDetailsSubtitle,
  destination: RoommateDetailsPage(
    roomId: _owner?.roomId ?? 0,
    currentTenantId: _owner?.id ?? 0,
  ),
),
            const Divider(height: 1),

  _buildMenuItem(
    context,
    icon: Icons.language_rounded,
    title: language.language,
subtitle: language.languageSubtitle,
    // title: 'Language',
    // subtitle: 'English / Telugu / Hindi',
    destination: const LanguagePage(),
  ),
  const Divider(height: 1),

// _buildMenuItem(
//   context,
//   icon: Icons.dark_mode_rounded,
//   title: "Appearance",
//   subtitle: "Light / Dark Mode",
//   destination: const ThemePage(),
// ),
const Divider(height: 1),

Consumer<ThemeProvider>(
  builder: (context, provider, child) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.dark_mode_rounded,
          color: AppColors.primary,
          size: 22,
        ),
      ),

      title: const Text(
        "Appearance",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),

      subtitle: Text(
        provider.isDarkMode ? "Dark Mode" : "Light Mode",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),

      trailing: Switch(
        value: provider.isDarkMode,
        onChanged: provider.toggleTheme,
      ),
    );
  },
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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: theme.colorScheme.onSurface),
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value.isNotEmpty ? value : '—',
            textAlign: TextAlign.end,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {
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
