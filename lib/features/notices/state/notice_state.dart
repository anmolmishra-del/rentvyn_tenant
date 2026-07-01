import 'package:rentvyn_tenant/features/notices/models/notice_model.dart';

class NoticeState {
  final bool loading;
  final String? error;
  final List<Notice> notices;

  const NoticeState({
    this.loading = false,
    this.error,
    this.notices = const [],
  });

  NoticeState copyWith({
    bool? loading,
    String? error,
    List<Notice>? notices,
  }) {
    return NoticeState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      notices: notices ?? this.notices,
    );
  }
}
