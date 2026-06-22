class ComplaintType {
  final int id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  ComplaintType({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplaintType.fromJson(
    Map<String, dynamic> json,
  ) {
    return ComplaintType(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}

class Complaint {
  final int id;
  final int hostelId;
  final int tenantId;
  final int ownerId;
  final int complaintTypeId;

  final String description;
  final String status;
  final String priority;

  final String createdAt;
  final String updatedAt;

  final ComplaintType? complaintType;

  Complaint({
    required this.id,
    required this.hostelId,
    required this.tenantId,
    required this.ownerId,
    required this.complaintTypeId,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.complaintType,
  });

  factory Complaint.fromJson(
    Map<String, dynamic> json,
  ) {
    return Complaint(
      id: json["id"] ?? 0,
      hostelId: json["hostel_id"] ?? 0,
      tenantId: json["tenant_id"] ?? 0,
      ownerId: json["owner_id"] ?? 0,
      complaintTypeId: json["complaint_type_id"] ?? 0,
      description: json["description"] ?? "",
      status: json["status"] ?? "",
      priority: json["priority"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      complaintType: json["complaint_type"] != null
          ? ComplaintType.fromJson(
              json["complaint_type"],
            )
          : null,
    );
  }
}