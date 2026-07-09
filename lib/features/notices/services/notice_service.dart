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
        // If API returns an empty list, let's also fallback to mock notices
        // so the user has something nice to see until notices are added.
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

}
