import 'package:flutter/material.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';

class PersonalDetailsPage extends StatelessWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Personal Details', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey[150] ?? const Color(0xFFF1F1F1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primary.withOpacity(0.08),
                      child: const Icon(Icons.badge_outlined, size: 36, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Primary Profile Info',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your registered personal details',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    _buildInfoTile(Icons.phone_iphone_rounded, 'Phone Number', '+91 9876543210'),
                    const Divider(height: 32),
                    _buildInfoTile(Icons.cake_outlined, 'Date of Birth', 'October 14, 2002'),
                    const Divider(height: 32),
                    _buildInfoTile(Icons.opacity_rounded, 'Blood Group', 'O+ Positive'),
                    const Divider(height: 32),
                    _buildInfoTile(Icons.contact_phone_outlined, 'Emergency Contact', 'Dad (+91 98765 00000)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
