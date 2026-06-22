// import 'package:flutter/material.dart';
// import 'package:rentvyn_tenant/core/constants/app_colors.dart';

// class TicketsTab extends StatelessWidget {
//   const TicketsTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final List<Map<String, dynamic>> tickets = [
//       {
//         'id': 'TK-9082',
//         'title': 'Room Wi-Fi Disconnecting',
//         'category': 'Internet & Wifi',
//         'status': 'In Progress',
//         'statusColor': Colors.orange,
//         'date': 'Raised on Jun 11, 2026',
//         'description': 'Wi-Fi connection drops frequently in Room 204B, especially in evenings.',
//       },
//       {
//         'id': 'TK-8941',
//         'title': 'AC Service Request',
//         'category': 'Room Maintenance',
//         'status': 'Open',
//         'statusColor': AppColors.primary,
//         'date': 'Raised on Jun 12, 2026',
//         'description': 'Air conditioner cooling is weak. Needs filter clean and check.',
//       },
//       {
//         'id': 'TK-8410',
//         'title': 'Broken Bathroom Door Handle',
//         'category': 'Fittings & Repairs',
//         'status': 'Resolved',
//         'statusColor': Colors.green,
//         'date': 'Resolved on Jun 08, 2026',
//         'description': 'Bathroom door handle got loose and detached. Resolved by locksmith.',
//       },
//     ];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Support Tickets', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//         elevation: 0, 
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemCount: tickets.length,
//         itemBuilder: (context, index) {
//           final ticket = tickets[index];
//           return Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.grey[200]!),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.01),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 )
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Top Header Row: ID, Category and Status
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       ticket['id'],
//                       style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: ticket['statusColor'].withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         ticket['status'],
//                         style: TextStyle(
//                           color: ticket['statusColor'],
//                           fontWeight: FontWeight.bold,
//                           fontSize: 11,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),

//                 // Title and description
//                 Text(
//                   ticket['title'],
//                   style: theme.textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   ticket['description'],
//                   style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
//                 ),
//                 const SizedBox(height: 16),
//                 const Divider(height: 1),
//                 const SizedBox(height: 12),

//                 // Footer Info: Date and Category tags
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       ticket['date'],
//                       style: TextStyle(color: Colors.grey[500], fontSize: 12),
//                     ),
//                     Text(
//                       ticket['category'],
//                       style: const TextStyle(
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {},
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         icon: const Icon(Icons.add_rounded),
//         label: const Text('Raise Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }
