import 'dart:convert';

import 'package:rentvyn_tenant/core/services/api_urls.dart';

import '../../../core/services/api_client.dart';



class AuthResponse {
  final bool success;
  final String? token;
  final String? message;

  AuthResponse({required this.success, this.token, this.message});
}
class AuthService {

  // 📲 SEND OTP
  static Future<bool> sendOtp(String phone) async {
    final res = await ApiClient.post(
      ApiUrls.sendOtp,
      body: {"phone_number": phone},
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }

  }
  
  static Future<bool> saveFcmToken({
    required String token,
    required int userId,
    required Map<String, dynamic> deviceInfo,
    String city = "Unknown",
    double latitude = 0.0,
    double longitude = 0.0,
    String role = "tenant",
  }) async {
    try {
      final res = await ApiClient.post(
        ApiUrls.saveFcmToken,
        body: {
          "token": token,
          "user_id": userId,
          "device_name": deviceInfo["device_name"],
          "brand": deviceInfo["brand"],
          "device_id": deviceInfo["device_id"],
          "platform": deviceInfo["platform"],
          "os_version": deviceInfo["os_version"],
          "city": city,
          "latitude": latitude,
          "longitude": longitude,
          "role": role,
        },
        requireAuth: true,
      );

      print("STATUS => ${res.statusCode}");
      print("BODY => ${res.body}");

      if (res.statusCode == 200) {
        print("✅ FCM token saved");
        return true;
      } else {
        print("❌ Failed");
        return false;
      }
    } catch (e) {
      print("❌ Error: $e");
      return false;
    }
  }
static Future<Map<String, dynamic>?> verifyOtp(
  String phone,
  String otp,
) async {
  try {
    final res = await ApiClient.post(
      ApiUrls.verifyOtp,
      body: {
        "phone_number": phone,
        "otp": otp,
      },
    );

    if (res.statusCode == 200) {
      final data =
          jsonDecode(res.body);

      return data;
    }

    return null;
  } catch (e) {
    print(
      "Verify OTP Error: $e",
    );

    return null;
  }
}}