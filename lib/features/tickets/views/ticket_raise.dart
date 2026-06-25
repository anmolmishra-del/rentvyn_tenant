import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/tickets/cubit/ticket_cubit.dart';
import 'package:rentvyn_tenant/features/tickets/state/ticket_state.dart';
import 'package:rentvyn_tenant/features/tickets/models/ticket_model.dart';
import 'package:rentvyn_tenant/features/tickets/views/tickets_page.dart';
import 'package:rentvyn_tenant/l10n/app_localizations.dart';


class TicketsTab extends StatefulWidget {
  const TicketsTab({super.key});

  @override
  State<TicketsTab> createState() => _TicketsTabState();
}

class _TicketsTabState extends State<TicketsTab> with SingleTickerProviderStateMixin {
  String _selectedStatusFilter = 'All'; // 'All', 'Open', 'In Progress', 'Resolved'
  late TabController _tabController;

  final List<String> _filters = ['All', 'Open', 'In Progress', 'Resolved'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedStatusFilter = _filters[_tabController.index];
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketsCubit>().loadTickets();
      context.read<TicketsCubit>().loadComplaintTypes();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "resolved":
      case "closed":
        return const Color(0xFF10B981); // Emerald Green
      case "open":
        return AppColors.primary;
      case "in_progress":
        return const Color(0xFFF59E0B); // Amber
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return const Color(0xFFEF4444); // Red
      case "normal":
      case "medium":
        return const Color(0xFF3B82F6); // Blue
      case "low":
        return const Color(0xFF10B981); // Green
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData getCategoryIcon(String? categoryName) {
    final name = categoryName?.toLowerCase() ?? '';
    if (name.contains('wifi') || name.contains('internet')) {
      return Icons.wifi_rounded;
    } else if (name.contains('ac') || name.contains('cooling') || name.contains('fan')) {
      return Icons.ac_unit_rounded;
    } else if (name.contains('water') || name.contains('plumbing') || name.contains('leak')) {
      return Icons.water_drop_rounded;
    } else if (name.contains('food') || name.contains('mess') || name.contains('canteen')) {
      return Icons.restaurant_rounded;
    } else if (name.contains('cleaning') || name.contains('housekeeping') || name.contains('wash')) {
      return Icons.cleaning_services_rounded;
    } else if (name.contains('electricity') || name.contains('power') || name.contains('light')) {
      return Icons.electric_bolt_rounded;
    } else if (name.contains('security') || name.contains('gate') || name.contains('key')) {
      return Icons.security_rounded;
    }
    return Icons.build_circle_rounded;
  }

  Color getCategoryColor(String? categoryName) {
    final name = categoryName?.toLowerCase() ?? '';
    if (name.contains('wifi') || name.contains('internet')) {
      return const Color(0xFF3B82F6); // Blue
    } else if (name.contains('ac') || name.contains('cooling') || name.contains('fan')) {
      return const Color(0xFF06B6D4); // Cyan
    } else if (name.contains('water') || name.contains('plumbing') || name.contains('leak')) {
      return const Color(0xFF0EA5E9); // Sky
    } else if (name.contains('food') || name.contains('mess') || name.contains('canteen')) {
      return const Color(0xFFF97316); // Orange
    } else if (name.contains('cleaning') || name.contains('housekeeping') || name.contains('wash')) {
      return const Color(0xFF10B981); // Emerald
    } else if (name.contains('electricity') || name.contains('power') || name.contains('light')) {
      return const Color(0xFFEAB308); // Yellow
    }
    return AppColors.primary;
  }

  String formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
    } catch (_) {
      if (dateStr.contains('T')) {
        return dateStr.split('T').first;
      }
      return dateStr;
    }
  }

  List<Complaint> _filterComplaints(List<Complaint> complaints) {
    final sorted = List<Complaint>.from(complaints);
    sorted.sort((a, b) {
      try {
        final dtA = DateTime.parse(a.createdAt);
        final dtB = DateTime.parse(b.createdAt);
        return dtB.compareTo(dtA);
      } catch (_) {
        return b.createdAt.compareTo(a.createdAt);
      }
    });

    if (_selectedStatusFilter == 'All') return sorted;
    return sorted.where((c) {
      final status = c.status.toLowerCase();
      if (_selectedStatusFilter == 'Open') return status == 'open';
      if (_selectedStatusFilter == 'In Progress') return status == 'in_progress';
      if (_selectedStatusFilter == 'Resolved') return status == 'resolved' || status == 'closed';
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        title:  Text(
          language.supportTickets,
          // "Support Tickets",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: () => context.read<TicketsCubit>().loadTickets(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<TicketsCubit, TicketsState>(
        builder: (context, state) {
          if (state.loading && state.complaints.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final allTickets = state.complaints;
          final filteredTickets = _filterComplaints(allTickets);

          final openCount = allTickets.where((c) => c.status.toLowerCase() == 'open').length;
          final progressCount = allTickets.where((c) => c.status.toLowerCase() == 'in_progress').length;
          final resolvedCount = allTickets.where((c) => c.status.toLowerCase() == 'resolved' || c.status.toLowerCase() == 'closed').length;

          return Column(
            children: [
              // Summary Banner Card
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _buildStatCard(language.total, allTickets.length.toString(), const Color(0xFF6C4AB6)),
                    const SizedBox(width: 10),
                    _buildStatCard(language.open, openCount.toString(), AppColors.primary),
                    const SizedBox(width: 10),
                    _buildStatCard(language.inProgress, progressCount.toString(), const Color(0xFFF59E0B)),
                    const SizedBox(width: 10),
                    _buildStatCard(language.resolved, resolvedCount.toString(), const Color(0xFF10B981)),
                  ],
                ),
              ),

              // Filter Tabs Header
              Container(
                color: Colors.white,
                width: double.infinity,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelColor: AppColors.primary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelColor: Colors.grey[500],
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: _filters.map((f) => Tab(text: f)).toList(),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    await context.read<TicketsCubit>().loadTickets();
                  },
                  child: filteredTickets.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: filteredTickets.length,
                          itemBuilder: (context, index) {
                            final complaint = filteredTickets[index];
                            return _buildTicketCard(complaint, theme);
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        elevation: 4,
        highlightElevation: 8,
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
        label:  Text(
          // "Raise Ticket",
          language.raiseTicket,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        onPressed: () async {
          final cubit = context.read<TicketsCubit>();
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: const RaiseComplaintPage(),
              ),
            ),
          );

          if (result == true) {
            cubit.loadTickets();
          }
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
        final language = AppLocalizations.of(context)!;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.12), width: 1.5),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
        final language = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 50),
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.07),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.confirmation_number_outlined,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  language.noTicketsFound,
                  // "No Tickets Found",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedStatusFilter == language.all
    ? language.noTicketsMessage
    : language.noTicketsFilterMessage,
                  // _selectedStatusFilter == 'All'
                  //     ? "You haven't raised any support tickets yet. Tap the button below to report an issue."
                  //     : "No tickets match the selected status filter '$_selectedStatusFilter'.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                if (_selectedStatusFilter != language.all)
                  OutlinedButton.icon(
                    onPressed: () {
                      _tabController.animateTo(0);
                    },
                    icon: const Icon(Icons.clear_all_rounded),
                    label: Text(language.viewAllTickets),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTicketCard(Complaint complaint, ThemeData theme) {
        final language = AppLocalizations.of(context)!;

    final statusColor = getStatusColor(complaint.status);
    final priorityColor = getPriorityColor(complaint.priority);
    // final categoryName = complaint.complaintType?.name ?? "Complaint";
    final categoryName =
    complaint.complaintType?.name ??
    language.complaint;
    final categoryIcon = getCategoryIcon(categoryName);
    final categoryColor = getCategoryColor(categoryName);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Container(
              decoration: BoxDecoration(
              border: Border(
          left: BorderSide(
            color: Colors.primaries[complaint.id.hashCode % Colors.primaries.length],
            width: 3,
          ),),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: ID, Priority, Options
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "#${complaint.id}",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: priorityColor.withOpacity(0.2), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: priorityColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
Text(
  complaint.priority.toLowerCase() == 'low'
      ? language.low
      : complaint.priority.toLowerCase() == 'normal'
          ? language.normal
          : language.high,

                                style: TextStyle(
                                  color: priorityColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.more_vert_rounded, color: Colors.grey[600], size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _showTicketActionSheet(complaint),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
              
                    // Row 2: Category Icon + Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            categoryIcon,
                            color: categoryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
  "${language.createdOn} ${formatDate(complaint.createdAt)}",                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Status Badge on the right
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: statusColor.withOpacity(0.15), width: 1),
                          ),
                          child: 
                            // complaint.status.replaceAll('_', ' ').toUpperCase(),
                            Text(
  complaint.status.toLowerCase() == 'open'
      ? language.open
      : complaint.status.toLowerCase() ==
              'in_progress'
          ? language.inProgress
          : language.resolved,

                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
              
                    // Row 3: Description text
                    Text(
                      complaint.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13.5,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTicketActionSheet(Complaint complaint) {
        final language = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                   language.ticketActions,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                  ),
                  title:  Text(
                   language.editComplaint,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  subtitle:  Text(language.editComplaintSubtitle),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    final complaintTypes = context.read<TicketsCubit>().state.complaintTypes;
                    _showEditComplaintSheet(complaint, complaintTypes);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                  ),
                  title: Text(
                    language.deleteComplaint,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.red),
                  ),
                  subtitle:  Text(language.deleteComplaintSubtitle),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showDeleteComplaintDialog(complaint);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditComplaintSheet(Complaint complaint, List<ComplaintType> complaintTypes) {
        final language = AppLocalizations.of(context)!;

    int currentTypeId = complaint.complaintTypeId;
    String currentPriority = complaint.priority;
    final controller = TextEditingController(text: complaint.description);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            ComplaintType? selectedType;
            if (complaintTypes.isNotEmpty) {
              selectedType = complaintTypes.firstWhere(
                (t) => t.id == currentTypeId,
                orElse: () => complaintTypes.first,
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                   language.editComplaint,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${language.ticketId}: #${complaint.id}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                     Text(
                      language.complaintCategory,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (selectedType == null)
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                      )
                    else
                      InkWell(
                        onTap: () {
                          _showCategorySelectionSheet(
                            context: context,
                            complaintTypes: complaintTypes,
                            currentSelectedId: currentTypeId,
                            onSelected: (id) {
                              setModalState(() {
                                currentTypeId = id;
                              });
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: getCategoryColor(selectedType.name).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  getCategoryIcon(selectedType.name),
                                  color: getCategoryColor(selectedType.name),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedType.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[400], size: 24),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                     Text(
                    language.priority,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildModalPriorityChip("low", language.low, const Color(0xFF10B981), currentPriority, (val) {
                          setModalState(() {
                            currentPriority = val;
                          });
                        }),
                        const SizedBox(width: 10),
                        _buildModalPriorityChip("normal", language.normal, const Color(0xFF3B82F6), currentPriority, (val) {
                          setModalState(() {
                            currentPriority = val;
                          });
                        }),
                        const SizedBox(width: 10),
                        _buildModalPriorityChip("high", language.high, const Color(0xFFEF4444), currentPriority, (val) {
                          setModalState(() {
                            currentPriority = val;
                          });
                        }),
                      ],
                    ),

                    const SizedBox(height: 20),

                     Text(
                      language.description,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller,
                      maxLines: 4,
                      maxLength: 300,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
hintText: language.enterUpdatedDescription,                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.pop(sheetContext),
                            child: Text(
                             language.cancel,
                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 1,
                            ),
                            onPressed: () async {
                              final text = controller.text.trim();
                              if (text.isEmpty) return;
                              Navigator.pop(sheetContext);

                              final updatedComplaint = Complaint(
                                id: complaint.id,
                                hostelId: complaint.hostelId,
                                tenantId: complaint.tenantId,
                                ownerId: complaint.ownerId,
                                complaintTypeId: currentTypeId,
                                description: text,
                                status: complaint.status,
                                priority: currentPriority,
                                createdAt: complaint.createdAt,
                                updatedAt: DateTime.now().toIso8601String(),
                              );

                              final messenger = ScaffoldMessenger.of(sheetContext);
                              final success = await context.read<TicketsCubit>().updateComplaint(
                                    complaint: updatedComplaint,
                                    description: text,
                                  );

                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(success ?language.complaintUpdatedSuccessfully : language.failedToUpdateComplaint),
                                  backgroundColor: success ? Colors.green : Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            },
                            child:  Text(language.saveChanges, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          );
          },
        );
      },
    );
  }

  void _showCategorySelectionSheet({
    
    required BuildContext context,
    required List<ComplaintType> complaintTypes,
    required int currentSelectedId,
    required Function(int) onSelected,
  }) {
      final language = AppLocalizations.of(context)!;
    showModalBottomSheet(
      
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                 SizedBox(height: 20),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                   language.selectCategory,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: complaintTypes.length,
                    itemBuilder: (context, index) {
                      final type = complaintTypes[index];
                      final isSelected = type.id == currentSelectedId;
                      final catIcon = getCategoryIcon(type.name);
                      final catColor = getCategoryColor(type.name);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? catColor.withOpacity(0.3) : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: isSelected ? catColor.withOpacity(0.04) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected ? catColor.withOpacity(0.12) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(catIcon, color: isSelected ? catColor : Colors.grey[600], size: 20),
                            ),
                            title: Text(
                              type.name,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? catColor : Colors.grey[800],
                              ),
                            ),
                            subtitle: type.description.isNotEmpty ? Text(type.description) : null,
                            trailing: isSelected
                                ? Icon(Icons.check_circle_rounded, color: catColor, size: 22)
                                : null,
                            onTap: () {
                              onSelected(type.id);
                              Navigator.pop(sheetContext);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalPriorityChip(
    
    String value,
    String label,
    Color color,
    String currentValue,
    Function(String) onTap,
  ) {
    final isSelected = currentValue == value;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.07) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade200,
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteComplaintDialog(Complaint complaint) {
    final language = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title:  Text(
           language.deleteComplaintTitle,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(
language.deleteComplaintMessage,            style: TextStyle(color: Colors.grey[600], height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                language.cancel,
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                
                final success = await context.read<TicketsCubit>().deleteComplaint(
                  complaint.id,
                );

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
success
 ? language.complaintDeletedSuccessfully
 : language.failedToDeleteComplaint                        ),
                      backgroundColor: success ? Colors.green : Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              },
              child:  Text(language.delete, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}