import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/tickets/cubit/ticket_cubit.dart';
import 'package:rentvyn_tenant/features/tickets/state/ticket_state.dart';
import 'package:rentvyn_tenant/features/tickets/models/ticket_model.dart';
import 'package:rentvyn_tenant/l10n/app_localizations.dart';

class RaiseComplaintPage extends StatefulWidget {
  const RaiseComplaintPage({super.key});

  @override
  State<RaiseComplaintPage> createState() => _RaiseComplaintPageState();
}

class _RaiseComplaintPageState extends State<RaiseComplaintPage> {
  final TextEditingController descriptionController = TextEditingController();
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    context.read<TicketsCubit>().resetCreateSuccess();
    context.read<TicketsCubit>().loadComplaintTypes();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  IconData getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
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

  Color getCategoryColor(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('wifi') || name.contains('internet')) {
      return const Color(0xFF3B82F6);
    } else if (name.contains('ac') || name.contains('cooling') || name.contains('fan')) {
      return const Color(0xFF06B6D4);
    } else if (name.contains('water') || name.contains('plumbing') || name.contains('leak')) {
      return const Color(0xFF0EA5E9);
    } else if (name.contains('food') || name.contains('mess') || name.contains('canteen')) {
      return const Color(0xFFF97316);
    } else if (name.contains('cleaning') || name.contains('housekeeping') || name.contains('wash')) {
      return const Color(0xFF10B981);
    } else if (name.contains('electricity') || name.contains('power') || name.contains('light')) {
      return const Color(0xFFEAB308);
    }
    return AppColors.primary;
  }

  void _showCategorySelectionSheet(BuildContext context, TicketsState state) {
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
                  child:Text(language.selectCategory,
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
                    itemCount: state.complaintTypes.length,
                    itemBuilder: (context, index) {
                      final type = state.complaintTypes[index];
                      final isSelected = type.id == state.complaintTypeId;
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
                              context.read<TicketsCubit>().changeComplaintType(type.id);
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

  @override
  Widget build(BuildContext context) {
      final language = AppLocalizations.of(context)!;
    return BlocListener<TicketsCubit, TicketsState>(
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              content: Text(state.error!),
            ),
          );
        }

        if (state.createSuccess && !_isPopped) {
          _isPopped = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
content: Text(language.complaintSubmittedSuccessfully)            ),
          );
          context.read<TicketsCubit>().resetCreateSuccess();
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF9F6),
        appBar: AppBar(
          title:  Text(
            // "Raise Complaint",
            language.raiseComplaint,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<TicketsCubit, TicketsState>(
          builder: (context, state) {
            // Determine selected category safely
            ComplaintType? selectedType;
            if (state.complaintTypes.isNotEmpty) {
              selectedType = state.complaintTypes.firstWhere(
                (t) => t.id == state.complaintTypeId,
                orElse: () => state.complaintTypes.first,
              );
            }

            final isLoaded = state.complaintTypes.isNotEmpty;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form header card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            language.complaintFormInfo,
                            // "Fill out this form to submit your issue. Our management team will check it and update the status.",
                            style: TextStyle(
                              color: AppColors.primary.withOpacity(0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section: Complaint Type Picker
                   Text(
                    language.complaintCategory,
                    // "Complaint Category",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (!isLoaded)
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        ),
                      ),
                    )
                  else
                    InkWell(
                      onTap: () => _showCategorySelectionSheet(context, state),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.01),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: getCategoryColor(selectedType!.name).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                getCategoryIcon(selectedType.name),
                                color: getCategoryColor(selectedType.name),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedType.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  if (selectedType.description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        selectedType.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
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

                  const SizedBox(height: 24),

                  // Section: Priority Selector
                   Text(
                    language.selectPriority,
                    // "Select Priority",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _buildPriorityChip(
  "low",
  language.low,
  const Color(0xFF10B981),
  state.priority,
),

_buildPriorityChip(
  "normal",
  language.normal,
  const Color(0xFF3B82F6),
  state.priority,
),

_buildPriorityChip(
  "high",
  language.high,
  const Color(0xFFEF4444),
  state.priority,
),
                      // _buildPriorityChip("low", "Low", const Color(0xFF10B981), state.priority),
                      // const SizedBox(width: 10),
                      // _buildPriorityChip("normal", "Normal", const Color(0xFF3B82F6), state.priority),
                      // const SizedBox(width: 10),
                      // _buildPriorityChip("high", "High", const Color(0xFFEF4444), state.priority),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section: Description Form Field
                  Text(
                    // "Description",
                    language.description,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: descriptionController,
                    maxLines: 6,
                    maxLength: 300,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                    decoration: InputDecoration(
                      hintText: language.descriptionHint,
                      // hintText: "Briefly explain the issue (e.g. WiFi not working since morning, leaking faucet in washroom...)",
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.all(16),
                      counterStyle: TextStyle(color: Colors.grey[500], fontSize: 11),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                        elevation: 2,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: state.loading || !isLoaded
                          ? null
                          : () async {
                              final text = descriptionController.text.trim();
                              if (text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
content: Text(language.pleaseDescribeIssue),                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                                return;
                              }

                              await context.read<TicketsCubit>().createComplaint(
                                    complaintTypeId: selectedType!.id,
                                    description: text,
                                    priority: state.priority,
                                  );
                            },
                      child: state.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          :  Text(
                              language.submitComplaint,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String value, String label, Color color, String currentValue) {
    final isSelected = currentValue == value;

    return Expanded(
      child: InkWell(
        onTap: () {
          context.read<TicketsCubit>().changePriority(value);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.07) : Colors.white,
            borderRadius: BorderRadius.circular(14),
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
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}