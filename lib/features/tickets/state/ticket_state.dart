import 'package:rentvyn_tenant/features/tickets/models/ticket_model.dart';

class TicketsState {
  final bool loading;
  final bool createSuccess;

  final String? error;

  final List<Complaint> complaints;
  final List<ComplaintType> complaintTypes;

  final int complaintTypeId;
  final String priority;

  const TicketsState({
    this.loading = false,
    this.createSuccess = false,
    this.error,
    this.complaints = const [],
    this.complaintTypes = const [],
    this.complaintTypeId = 1,
    this.priority = "normal",
  });

  TicketsState copyWith({
    bool? loading,
    bool? createSuccess,
    String? error,
    List<Complaint>? complaints,
    List<ComplaintType>? complaintTypes,
    int? complaintTypeId,
    String? priority,
  }) {
    return TicketsState(
      loading: loading ?? this.loading,
      createSuccess:
          createSuccess ?? this.createSuccess,
      error: error ?? this.error,
      complaints:
          complaints ?? this.complaints,
      complaintTypes:
          complaintTypes ?? this.complaintTypes,
      complaintTypeId:
          complaintTypeId ?? this.complaintTypeId,
      priority:
          priority ?? this.priority,
    );
  }
}