import 'package:rentvyn_tenant/features/payments/models/bill_model.dart';

class BillsState {
  final bool loading;
  final String? error;
  final List<BillModel> bills;

  const BillsState({
    this.loading = false,
    this.error,
    this.bills = const [],
  });

  BillsState copyWith({
    bool? loading,
    String? error,
    List<BillModel>? bills,
  }) {
    return BillsState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      bills: bills ?? this.bills,
    );
  }

  // Helper to find the first pending bill
  BillModel? get activePendingBill {
    final pending = bills.where((b) => b.status.toLowerCase() == 'pending').toList();
    return pending.isNotEmpty ? pending.first : null;
  }
}
