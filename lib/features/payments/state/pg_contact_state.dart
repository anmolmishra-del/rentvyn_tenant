class PgContactState {
  final bool loading;
  final String? error;
  final Map<String, dynamic>? contact;

  const PgContactState({
    this.loading = false,
    this.error,
    this.contact,
  });

  PgContactState copyWith({
    bool? loading,
    String? error,
    Map<String, dynamic>? contact,
  }) {
    return PgContactState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      contact: contact ?? this.contact,
    );
  }
}
