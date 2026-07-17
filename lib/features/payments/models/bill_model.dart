class BillModel {
  final int id;
  final int hostelId;
  final int tenantId;
  final String dueDate;
  final String status;
  final String billNumber;
  final double amount;
  final String description;

  BillModel({
    required this.id,
    required this.hostelId,
    required this.tenantId,
    required this.dueDate,
    required this.status,
    required this.billNumber,
    required this.amount,
    required this.description,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] ?? 0,
      hostelId: json['hostel_id'] ?? 0,
      tenantId: json['tenant_id'] ?? 0,
      dueDate: json['due_date'] ?? '',
      status: json['status'] ?? '',
      billNumber: json['bill_number'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hostel_id': hostelId,
      'tenant_id': tenantId,
      'due_date': dueDate,
      'status': status,
      'bill_number': billNumber,
      'amount': amount,
      'description': description,
    };
  }
}
