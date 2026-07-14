import 'dart:convert';
import 'package:rentvyn_tenant/features/notices/models/notice_model.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/api_urls.dart';

class NoticeService {
  static Future<List<NoticeModel>> getHostelNotices(int hostelId) async {
    try {
      print("GET HOSTEL NOTICES => hostelId: $hostelId");
      final res = await ApiClient.get(
        ApiUrls.hostelNotices(hostelId),
        requireAuth: true,
      );

      print("GET HOSTEL NOTICES STATUS => ${res.statusCode}");
      print("GET HOSTEL NOTICES BODY => ${res.body}");

      if (res.statusCode == 200){
        final List data = jsonDecode(res.body);
        final notices = data.map((e) => NoticeModel.fromJson(e)).toList();
        if (notices.isEmpty) {
          print("No notices returned from API, using mock fallbacks.");
          return [];
        }
        return notices;
      } else {
        print("API returned non-200 status, using mock fallbacks.");
        return [];
      }
    } catch (e) {
      print("GET HOSTEL NOTICES ERROR => $e. Falling back to mock notices.");
      return [];
    }
  }

  // static List<NoticeModel> _getMockNotices(int hostelId) {
  //   final now = DateTime.now();
  //   return [
  //     NoticeModel(
  //       id: 101,
  //       hostelId: hostelId,
  //       title: "Urgent: Water Tank Maintenance",
  //       description: "The primary water tanks will undergo annual cleaning this Sunday from 9:00 AM to 1:00 PM. Water supply will be completely suspended during this window. Please store water in advance and plan accordingly.",
  //       fromDate: DateTime(now.year, now.month, now.day + 2, 9, 0).toIso8601String(),
  //       toDate: DateTime(now.year, now.month, now.day + 2, 13, 0).toIso8601String(),
  //       createdAt: now.subtract(const Duration(hours: 3)).toIso8601String(),
  //       updatedAt: now.subtract(const Duration(hours: 3)).toIso8601String(),
  //     ),
  //     NoticeModel(
  //       id: 102,
  //       hostelId: hostelId,
  //       title: "Monthly PG Social & Dinner",
  //       description: "We are hosting our monthly community social dinner this Friday at 7:30 PM in the central lawn area. Come join us for an evening of live music, interactive games, and a grand buffet! We hope to see you all there.",
  //       fromDate: DateTime(now.year, now.month, now.day + 4, 19, 30).toIso8601String(),
  //       toDate: DateTime(now.year, now.month, now.day + 4, 22, 30).toIso8601String(),
  //       createdAt: now.subtract(const Duration(days: 1)).toIso8601String(),
  //       updatedAt: now.subtract(const Duration(days: 1)).toIso8601String(),
  //     ),
  //     NoticeModel(
  //       id: 103,
  //       hostelId: hostelId,
  //       title: "High-Speed Wi-Fi Upgrades Complete",
  //       description: "New enterprise routers have been installed on floors 1 through 4. Connect to the 'Rentvyn_Max_5G' network using the credentials listed in your welcome kit to enjoy 200Mbps+ speeds.",
  //       fromDate: now.subtract(const Duration(days: 1)).toIso8601String(),
  //       toDate: now.subtract(const Duration(days: 1)).toIso8601String(),
  //       createdAt: now.subtract(const Duration(days: 2)).toIso8601String(),
  //       updatedAt: now.subtract(const Duration(days: 2)).toIso8601String(),
  //     ),
  //   ];
  // }
}
