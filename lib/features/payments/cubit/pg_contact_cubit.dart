import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';
import 'package:rentvyn_tenant/features/auth/cubit/auth_service.dart';
import 'package:rentvyn_tenant/features/payments/state/pg_contact_state.dart';

class PgContactCubit extends Cubit<PgContactState> {
  PgContactCubit() : super(const PgContactState());

  Future<void> loadPgContact() async {
    try {
      emit(state.copyWith(loading: true, error: null));

      final tenant = await AuthStorage.getOwner();
      if (tenant == null || tenant.hostelId == null) {
        emit(state.copyWith(loading: false, error: "Tenant or hostel information missing"));
        return;
      }

      print("--- LOADING PG CONTACT FOR HOSTEL ${tenant.hostelId} ---");
      final contact = await AuthService.getPgContact(tenant.hostelId!);

      emit(state.copyWith(
        loading: false,
        contact: contact,
      ));
    } catch (e) {
      print("LOAD PG CONTACT ERROR => $e");
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
