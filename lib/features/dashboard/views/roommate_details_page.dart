// import 'package:flutter/material.dart';
// import 'package:rentvyn_tenant/core/constants/app_colors.dart';

// class RoommateDetailsPage extends StatelessWidget {
//   const RoommateDetailsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text('Roommates', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(28),
//                 border: Border.all(color: Colors.grey[150] ?? const Color(0xFFF1F1F1)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.015),
//                     blurRadius: 16,
//                     offset: const Offset(0, 8),
//                   )
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: const Icon(Icons.meeting_room_outlined, color: AppColors.primary, size: 24),
//                       ),
//                       const SizedBox(width: 16),
//                       const Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Room 204B occupants',
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
//                           ),
//                           SizedBox(height: 2),
//                           Text(
//                             'Stanza Living Premium Wing',
//                             style: TextStyle(color: Colors.grey, fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   _buildRoommateTile('Daniel Craig', 'Bedsheet occupant A', '+91 98765 11111'),
//                   const Divider(height: 24),
//                   _buildRoommateTile('Ethan Hunt', 'Bedsheet occupant C (Pending check-in)', '+91 98765 22222'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoommateTile(String name, String status, String phone) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 22,
//           backgroundColor: AppColors.secondary.withOpacity(0.1),
//           child: const Icon(Icons.person_outline_rounded, size: 22, color: AppColors.secondary),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//               const SizedBox(height: 2),
//               Text(status, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
//             ],
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.phone_enabled_rounded, color: AppColors.primary, size: 18),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }
// }
