class NoticeModel {
  int hostelId;
  String description;
  String? title;
  String? fromDate;
  String? toDate;
  int? id;
  String? createdAt;
  String? updatedAt;

  NoticeModel(
      {required this.hostelId,
      this.title,
      required this.description,
      this.fromDate,
      this.toDate,
      this.id,
      this.createdAt,
      this.updatedAt});

  NoticeModel.fromJson(Map<String, dynamic> json)
      : hostelId = json['hostel_id'],
        title = json['title'],
        description = json['description'],
        fromDate = json['from_date'],
        toDate = json['to_date'],
        id = json['id'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hostel_id'] = this.hostelId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
