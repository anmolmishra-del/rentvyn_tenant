// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rentvyn_tenant/core/constants/app_colors.dart';
// import 'package:rentvyn_tenant/features/tickets/cubit/ticket_cubit.dart';
// import 'package:rentvyn_tenant/features/tickets/views/tickets_page.dart';

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
//         onPressed: () {
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => BlocProvider(
//       create: (_) => TicketsCubit(),
//       child: const RaiseComplaintPage(),
//     ),
//   ),
// );
// },
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         icon: const Icon(Icons.add_rounded),
//         label: const Text('Raise Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/tickets/cubit/ticket_cubit.dart';
import 'package:rentvyn_tenant/features/tickets/state/ticket_state.dart';
import 'package:rentvyn_tenant/features/tickets/views/tickets_page.dart';

class TicketsTab extends StatefulWidget {
  const TicketsTab({super.key});

  @override
  State<TicketsTab> createState() =>
      _TicketsTabState();
}

class _TicketsTabState
    extends State<TicketsTab> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      context
          .read<TicketsCubit>()
          .loadTickets();
    });
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "resolved":
        return Colors.green;

      case "closed":
        return Colors.green;

      case "open":
        return AppColors.primary;

      case "in_progress":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Support Tickets",//
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: BlocBuilder<
          TicketsCubit,
          TicketsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (state.complaints.isEmpty) {
            return const Center(
              child: Text(
                "No Complaints Found",
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context
                  .read<TicketsCubit>()
                  .loadTickets();
            },
            child: ListView.builder(
              padding:
                  const EdgeInsets.all(16),
              itemCount:
                  state.complaints.length,
              itemBuilder:
                  (context, index) {
                final complaint =
                    state.complaints[index];

                final statusColor =
                    getStatusColor(
                  complaint.status,
                );

                return Container(
                  margin:
                      const EdgeInsets.only(
                    bottom: 16,
                  ),
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(
                      color: Colors
                          .grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                          0.02,
                        ),
                        blurRadius: 10,
                        offset:
                            const Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      // Row(
                      //   mainAxisAlignment:
                      //       MainAxisAlignment
                      //           .spaceBetween,
                      //   children: [
                      //     Text(
                      //       "#${complaint.id}",
                      //       style:
                      //           const TextStyle(
                      //         fontWeight:
                      //             FontWeight
                      //                 .bold,
                      //         color:
                      //             Colors.grey,
                      //       ),
                      //     ),

                      //     Container(
                      //       padding:
                      //           const EdgeInsets.symmetric(
                      //         horizontal:
                      //             10,
                      //         vertical:
                      //             4,
                      //       ),
                      //       decoration:
                      //           BoxDecoration(
                      //         color:
                      //             statusColor
                      //                 .withOpacity(
                      //           .1,
                      //         ),
                      //         borderRadius:
                      //             BorderRadius.circular(
                      //           8,
                      //         ),
                      //       ),
                      //       child: Text(
                      //         complaint
                      //             .status
                      //             .toUpperCase(),
                      //         style:
                      //             TextStyle(
                      //           color:
                      //               statusColor,
                      //           fontWeight:
                      //               FontWeight
                      //                   .bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
Row(
  children: [
    Expanded(
      child: Text(
        "#${complaint.id}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ),

    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(.1),
        borderRadius:
            BorderRadius.circular(8),
      ),
      child: Text(
        complaint.status.toUpperCase(),
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    const SizedBox(width: 8),

    IconButton(
  icon: const Icon(
    Icons.delete_outline,
    color: Colors.red,
  ),

  onPressed: () async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Delete Complaint",
        ),
        content: const Text(
          "Are you sure you want to delete this complaint?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              false,
            ),
            child: const Text(
              "Cancel",
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(
              context,
              true,
            ),
            child: const Text(
              "Delete",
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success =
          await context
              .read<TicketsCubit>()
              .deleteComplaint(
                complaint.id,
              );

      if (success) {
        ScaffoldMessenger.of(
                context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Complaint Deleted Successfully",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
                context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Failed To Delete Complaint",
            ),
          ),
        );
      }
    }
  },
),
  ],),
                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        complaint
                                .complaintType
                                ?.name ??
                            "Complaint",
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        complaint
                            .description,
                        style:
                            TextStyle(
                          color: Colors
                              .grey[600],
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),

Align(
  alignment: Alignment.centerRight,
  child: TextButton.icon(
  onPressed: () async {
  final controller =
      TextEditingController(
    text: complaint.description,
  );

  final result =
      await showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(
        "Edit Complaint",
      ),
      content: TextField(
        controller: controller,
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context),
          child: const Text(
            "Cancel",
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              controller.text,
            );
          },
          child: const Text(
            "Update",
          ),
        ),
      ],
    ),
  );

  if (result != null &&
      result.isNotEmpty) {
    await context
        .read<TicketsCubit>()
        .updateComplaint(
          complaintId:
              complaint.id,
          description: result,
        );
  }
},
    icon: const Icon(
      Icons.edit,
      size: 18,
      color: AppColors.primary,
    ),
    label: const Text(
      "Edit",
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),
                      const SizedBox(
                        height: 16,
                      ),

                      const Divider(),

                      const SizedBox(
                        height: 12,
                      ),

                      Row(
                        // mainAxisAlignment:
                        //     MainAxisAlignment
                        //         .spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              complaint
                                  .createdAt,
                                    overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(
                                color: Colors
                                    .grey[500],
                                fontSize:
                                    12,
                              ),
                            ),
                          ),

                          Text(
                            complaint
                                    .priority
                                    .isEmpty
                                ? "-"
                                : complaint
                                    .priority
                                    .toUpperCase(),
                            style:
                                const TextStyle(
                              color:
                                  AppColors
                                      .primary,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor:
            AppColors.primary,
        foregroundColor:
            Colors.white,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          "Raise Ticket",
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
        onPressed: () async {
          final result =
              await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  BlocProvider.value(
                value: context.read<
                    TicketsCubit>(),
                child:
                    const RaiseComplaintPage(),
              ),
            ),
          );

          if (result == true) {
            context
                .read<TicketsCubit>()
                .loadTickets();
          }
        },
      ),
    );
  }
}