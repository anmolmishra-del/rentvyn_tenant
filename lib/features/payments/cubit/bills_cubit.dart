import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/features/auth/cubit/auth_service.dart';
import 'package:rentvyn_tenant/features/payments/models/bill_model.dart';
import 'package:rentvyn_tenant/features/payments/state/bills_state.dart';

class BillsCubit extends Cubit<BillsState> {
  BillsCubit() : super(const BillsState());

  Future<void> loadBills() async {
    try {
      emit(state.copyWith(loading: true, error: null));

      final rawBills = await AuthService.getMyBills();
      if (rawBills == null) {
        emit(state.copyWith(loading: false, error: "Failed to load bills"));
        return;
      }

      final parsed = rawBills.map((b) => BillModel.fromJson(b as Map<String, dynamic>)).toList();

      emit(state.copyWith(
        loading: false,
        bills: parsed,
      ));
    } catch (e) {
      print("LOAD BILLS ERROR => $e");
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
  // Future<void> verifyPayment({
  //   required int billId,
  //   required String paymentId,
  //   required String orderId,
  //   required String signature,
  // }) async {
  //   try {
  //     emit(state.copyWith(loading: true, error: null));

  //     final success = await AuthService.verifyPayment(
  //       billId: billId,
  //       paymentId: paymentId,
  //       orderId: orderId,
  //       signature: signature,
  //     );

  //     if (success) {
  //       // Reload bills after successful verification
  //       await loadBills();
  //     } else {
  //       emit(state.copyWith(loading: false, error: "Payment verification failed"));
  //     }
  //   } catch (e) {
  //     print("VERIFY PAYMENT ERROR => $e");
  //     emit(state.copyWith(loading: false, error: e.toString()));
  //   }
  // }
}
