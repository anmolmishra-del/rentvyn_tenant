import 'package:flutter/material.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';

class VerificationDetailsPage extends StatelessWidget {
  const VerificationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Police Verification', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
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
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.gpp_good_rounded, color: Colors.green, size: 48),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Background Check Cleared',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Your profile is fully verified by local police cell.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildDetailRow('Verification Method', 'Aadhaar e-KYC & Police Portal'),
                  const Divider(height: 32),
                  _buildDetailRow('Reference No', 'PV-UP-2026-894'),
                  const Divider(height: 32),
                  _buildDetailRow('Verification Date', 'June 02, 2026'),
                  const Divider(height: 32),
                  _buildDetailRow('Status', 'Verified (Clear)', textColor: Colors.green),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Police verification is a mandatory process for all co-living tenants as per local guidelines.',
                            style: TextStyle(color: Colors.grey[700], fontSize: 11, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.black87,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
