class Notice {
  final int id;
  final int hostelId;
  final String title;
  final String content;
  final String type; // 'urgent', 'maintenance', 'info'
  final String createdAt;
  final String updatedAt;

  Notice({
    required this.id,
    required this.hostelId,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] ?? 0,
      hostelId: json['hostel_id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? json['description'] ?? '',
      type: json['type'] ?? 'info',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hostel_id': hostelId,
      'title': title,
      'content': content,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
