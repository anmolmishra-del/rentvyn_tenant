// // import 'package:flutter/material.dart';
// // import 'package:rentvyn_tenant/core/constants/app_colors.dart';

// // class AgreementDetailsPage extends StatelessWidget {
// //   const AgreementDetailsPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.background,
// //       appBar: AppBar(
// //         title: const Text('Rental Agreement', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: SingleChildScrollView(
// //         physics: const BouncingScrollPhysics(),
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             const SizedBox(height: 10),
// //             Container(
// //               padding: const EdgeInsets.all(24),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(28),
// //                 border: Border.all(color: Colors.grey[150] ?? const Color(0xFFF1F1F1)),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.015),
// //                     blurRadius: 16,
// //                     offset: const Offset(0, 8),
// //                   )
// //                 ],
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Center(
// //                     child: Column(
// //                       children: [
// //                         CircleAvatar(
// //                           radius: 36,
// //                           backgroundColor: AppColors.primary.withOpacity(0.08),
// //                           child: const Icon(Icons.assignment_outlined, size: 36, color: AppColors.primary),
// //                         ),
// //                         const SizedBox(height: 16),
// //                         const Text(
// //                           'Stanza Living Agreement',
// //                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
// //                         ),
// //                         const SizedBox(height: 4),
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //                           decoration: BoxDecoration(
// //                             color: Colors.green.withOpacity(0.08),
// //                             borderRadius: BorderRadius.circular(100),
// //                           ),
// //                           child: const Text(
// //                             'Active',
// //                             style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 32),
// //                   _buildDetailRow('Agreement ID', 'AGR-STN-2026-04'),
// //                   const Divider(height: 32),
// //                   _buildDetailRow('Duration', 'Jun 01, 2026 - May 31, 2027'),
// //                   const Divider(height: 32),
// //                   _buildDetailRow('Security Deposit', '₹29,000.00 (Paid)'),
// //                   const Divider(height: 32),
// //                   _buildDetailRow('Monthly Rent Due Date', '5th of every month'),
// //                   const Divider(height: 32),
// //                   _buildDetailRow('Notice Period', '1 Month'),
// //                   const SizedBox(height: 32),
// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton.icon(
// //                       onPressed: () {},
// //                       icon: const Icon(Icons.cloud_download_outlined, size: 20, color: Colors.white),
// //                       label: const Text('Download PDF Agreement', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: AppColors.primary,
// //                         padding: const EdgeInsets.symmetric(vertical: 16),
// //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //                         elevation: 0,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildDetailRow(String label, String value) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           label,
// //           style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500),
// //         ),
// //         Text(
// //           value,
// //           style: const TextStyle(
// //             fontWeight: FontWeight.bold,
// //             color: Colors.black87,
// //             fontSize: 14,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:rentvyn_tenant/core/constants/app_colors.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

// class AgreementDetailsPage extends StatefulWidget {
//   final String pdfUrl;

//   const AgreementDetailsPage({
//     super.key,
//     required this.pdfUrl,
//   });

//   @override
//   State<AgreementDetailsPage> createState() =>
//       _AgreementDetailsPageState();
// }

// class _AgreementDetailsPageState
//     extends State<AgreementDetailsPage> {
//   final GlobalKey<SfSignaturePadState> _signatureKey =
//       GlobalKey<SfSignaturePadState>();

//   void _showSignaturePad() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius:
//             BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: SizedBox(
//             height: 450,
//             child: Column(
//               children: [
//                 const Text(
//                   "Digital Signature",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.grey.shade400,
//                       ),
//                       borderRadius:
//                           BorderRadius.circular(12),
//                     ),
//                     child: SfSignaturePad(
//                       key: _signatureKey,
//                       backgroundColor: Colors.white,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           _signatureKey.currentState?.clear();
//                         },
//                         child: const Text("Clear"),
//                       ),
//                     ),

//                     const SizedBox(width: 12),

//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           ui.Image image =
//                               await _signatureKey.currentState!
//                                   .toImage();

//                           print(image);

//                           Navigator.pop(context);

//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 "Signature Captured Successfully",
//                               ),
//                             ),
//                           );
//                         },
//                         child:
//                             const Text("Save Signature"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: const Text(
//           "Rental Agreement",
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.black87,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: widget.pdfUrl.isEmpty
//           ? const Center(
//               child: Text(
//                 "Rental Agreement not available",
//               ),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: SfPdfViewer.network(
//                     widget.pdfUrl,
//                   ),
//                 ),

//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   color: Colors.white,
//                   child: SafeArea(
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 55,
//                       child: ElevatedButton.icon(
//                         onPressed: _showSignaturePad,
//                         icon: const Icon(Icons.draw),
//                         label: const Text(
//                           "Digital Signature",
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               AppColors.primary,
//                           foregroundColor: Colors.white,
//                           shape:
//                               RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.circular(14),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
