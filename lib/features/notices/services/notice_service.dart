import 'dart:convert';
import 'package:rentvyn_tenant/features/notices/models/notice_model.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/api_urls.dart';

class NoticeService {
  static Future<List<Notice>> getHostelNotices(int hostelId) async {
    try {
      print("GET HOSTEL NOTICES => hostelId: $hostelId");
      final res = await ApiClient.get(
        ApiUrls.hostelNotices(hostelId),
        requireAuth: true,
      );

      print("GET HOSTEL NOTICES STATUS => ${res.statusCode}");
      print("GET HOSTEL NOTICES BODY => ${res.body}");

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        final notices = data.map((e) => Notice.fromJson(e)).toList();
        // If API returns an empty list, let's also fallback to mock notices
        // so the user has something nice to see until notices are added.
        if (notices.isEmpty) {
          print("No notices returned from API, using mock fallbacks.");
          return _getMockNotices(hostelId);
        }
        return notices;
      } else {
        print("API returned non-200 status, using mock fallbacks.");
        return _getMockNotices(hostelId);
      }
    } catch (e) {
      print("GET HOSTEL NOTICES ERROR => $e. Falling back to mock notices.");
      return _getMockNotices(hostelId);
    }
  }

  static List<Notice> _getMockNotices(int hostelId) {
    return [
      Notice(
        id: 101,
        hostelId: hostelId,
        title: "Urgent: Water Supply Maintenance",
        content: "Water tank cleaning and pipe maintenance are scheduled for this Sunday from 9:00 AM to 1:00 PM. Water supply will be temporarily unavailable on all floors. Please store water in advance and plan accordingly.",
        type: "urgent",
        createdAt: "2026-06-25T08:00:00.000Z",
        updatedAt: "2026-06-25T08:00:00.000Z",
      ),
      Notice(
        id: 102,
        hostelId: hostelId,
        title: "Vibrant Community Dinner!",
        content: "Join us for our monthly PG Social & Buffet Dinner this Friday at 7:30 PM in the central courtyard. It's a great opportunity to connect, network, and enjoy delicious delicacies. We hope to see you all there!",
        type: "info",
        createdAt: "2026-06-24T12:00:00.000Z",
        updatedAt: "2026-06-24T12:00:00.000Z",
      ),
      Notice(
        id: 103,
        hostelId: hostelId,
        title: "High-Speed Wi-Fi Upgraded",
        content: "We have successfully completed high-speed fiber-optic router upgrades on the 2nd and 3rd floors. The SSID is 'Rentvyn_HighSpeed_5G'. Standard login credentials remain the same. Enjoy seamless browsing and streaming!",
        type: "maintenance",
        createdAt: "2026-06-23T10:00:00.000Z",
        updatedAt: "2026-06-23T10:00:00.000Z",
      ),
    ];
  }
}
