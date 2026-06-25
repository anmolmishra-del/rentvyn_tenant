import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';
import 'package:rentvyn_tenant/features/tickets/cubit/ticket_service.dart';
import 'package:rentvyn_tenant/features/tickets/state/ticket_state.dart';
import 'package:rentvyn_tenant/features/tickets/models/ticket_model.dart';

class TicketsCubit extends Cubit<TicketsState> {
  TicketsCubit() : super(TicketsState());

  Future<void> createComplaint({
    required int complaintTypeId,
    required String description,
    required String priority,
  }) async {
    try {
      emit(
        state.copyWith(
          loading: true,
          createSuccess: false,
          error: null,
        ),
      );

      final tenant = await AuthStorage.getOwner();

      print(
        "TENANT DATA => ${tenant?.toJson()}",
      );

      if (tenant == null) {
        emit(
          state.copyWith(
            loading: false,
            error: "Tenant not found",
          ),
        );
        return;
      }

      final success = await TicketsService.createComplaint(
        hostelId: tenant.hostelId,
        tenantId: tenant.id,
        // ownerId: 6,
         ownerId: tenant.ownerId ?? 0,    
        complaintTypeId: complaintTypeId,
        description: description,
        priority: priority,
      );
      print("HOSTEL ID => ${tenant.hostelId}");
      print("HOSTEL OWNER ID => ${tenant.ownerId}");
      print(
        "CREATE SUCCESS => $success",
      );

      if (success) {
        await loadTickets();
      }

      emit(
        state.copyWith(
          loading: false,
          createSuccess: success,
        ),
      );
    } catch (e) {
      print(
        "CREATE COMPLAINT ERROR => $e",
      );

      emit(
        state.copyWith(
          loading: false,
          createSuccess: false,
          error: e.toString(),
        ),
      );
    }
  }
Future<void> loadComplaintTypes() async {
  try {
    final types =
        await TicketsService.getComplaintTypes();

    emit(
      state.copyWith(
        complaintTypes: types,
      ),
    );
  } catch (e) {
    print(
      "LOAD TYPES ERROR => $e",
    );
  }
}
Future<bool> deleteComplaint(
  int complaintId,
) async {
  try {
    emit(
      state.copyWith(
        loading: true,
      ),
    );

    final success =
        await TicketsService.deleteComplaint(
      complaintId,
    );

    if (success) {
      await loadTickets();
    }

    emit(
      state.copyWith(
        loading: false,
      ),
    );

    return success;
  } catch (e) {
    emit(
      state.copyWith(
        loading: false,
        error: e.toString(),
      ),
    );

    return false;
  }
}
  Future<bool> updateComplaint({
    required Complaint complaint,
    required String description,
  }) async {
    try {
      emit(
        state.copyWith(
          loading: true,
        ),
      );

      final success = await TicketsService.updateComplaint(
        complaintId: complaint.id,
        hostelId: complaint.hostelId,
        tenantId: complaint.tenantId,
        ownerId: complaint.ownerId,
        complaintTypeId: complaint.complaintTypeId,
        description: description,
        status: complaint.status,
        priority: complaint.priority,
      );

      if (success) {
        await loadTickets();
      }

      emit(
        state.copyWith(
          loading: false,
        ),
      );

      return success;
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );

      return false;
    }
  }
  Future<void> loadTickets() async {
    try {
      emit(state.copyWith(loading: true));

      final tenant =
          await AuthStorage.getOwner();

      if (tenant == null || tenant.id == 0) {
        emit(
          state.copyWith(
            loading: false,
            error: "Invalid Tenant",
          ),
        );
        return;
      }

      final tickets =
          await TicketsService.getTenantTickets(
        tenant.id,
      );

      emit(
        state.copyWith(
          loading: false,
          complaints: tickets,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
    }
  }

  void changeComplaintType(int value) {
    emit(
      state.copyWith(
        complaintTypeId: value,
      ),
    );
  }

  void changePriority(String value) {
    emit(
      state.copyWith(
        priority: value,
      ),
    );
  }

  void resetCreateSuccess() {
    emit(
      state.copyWith(
        createSuccess: false,
      ),
    );
  }
}