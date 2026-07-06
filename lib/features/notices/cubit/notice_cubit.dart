import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';
import 'package:rentvyn_tenant/features/notices/services/notice_service.dart';
import 'package:rentvyn_tenant/features/notices/state/notice_state.dart';

class NoticeCubit extends Cubit<NoticeState> {
  NoticeCubit() : super(const NoticeState());

  Future<void> loadNotices() async {
    try {
      emit(state.copyWith(loading: true, error: null));

      final tenant = await AuthStorage.getOwner();

      if (tenant == null) {
        emit(
          state.copyWith(
            loading: false,
            error: "Tenant not logged in",
          ),
        );
        return;
      }

      print("--- LOADING NOTICES FOR TENANT ---");
      print("Tenant ID: ${tenant.id}");
      print("Tenant Name: ${tenant.name}");
      print("Hostel ID: ${tenant.hostelId}");
      print("----------------------------------");

      final notices = await NoticeService.getHostelNotices(tenant.hostelId);

      // Sort notices so that latest notices (newer dates / higher IDs) come first
      final sortedNotices = List.of(notices);
      sortedNotices.sort((a, b) {
        try {
          final dateA = DateTime.parse(a.createdAt ?? "");
          final dateB = DateTime.parse(b.updatedAt ?? "");
          return dateB.compareTo(dateA); // Descending order (latest first)
        } catch (_) {
          return b.id!.compareTo(a.id!); // Fallback to ID comparison desc
        }
      });

      emit(
        state.copyWith(
          loading: false,
          notices: sortedNotices,
        ),
      );
    } catch (e) {
      print("LOAD NOTICES ERROR => $e");
      emit(
        state.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
    }
  }
}
