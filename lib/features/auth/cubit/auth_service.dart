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
  print("VERIFY OTP STATUS => ${res.statusCode}");
    print("VERIFY OTP BODY => ${res.body}");
    if (res.statusCode == 200) {
      final data =
          jsonDecode(res.body);
   print("RAW RESPONSE => ${res.body}");
   
  print("ACCESS TOKEN => ${data["access_token"]}");
  print("OWNER ID => ${data["owner_id"]}");
  print("TENANT => ${data["tenant"]}");
  print("HOSTEL => ${data["tenant"]["hostel"]}");
  print("HOSTEL NAME => ${data["tenant"]["hostel"]["name"]}");
print("HOSTEL FROM RESPONSE => ${data["tenant"]["hostel"]}");
print("HOSTEL NAME => ${data["tenant"]["hostel"]?["name"]}");
      return data;
    }

    return null;
  } catch (e) {
    print(
      "Verify OTP Error: $e",
    );

    return null;
  }
}

  static Future<Map<String, dynamic>?> getPgContact(int hostelId) async {
    try {
      final res = await ApiClient.get(
        ApiUrls.pgContact(hostelId),
        requireAuth: true,
      );
      print("GET PG CONTACT STATUS => ${res.statusCode}");
      print("GET PG CONTACT BODY => ${res.body}");
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return null;
    } catch (e) {
      print("Get PG Contact Error: $e");
      return null;
    }
  }

  static Future<bool> logout({String? fcmToken}) async {
    try {
      final res = await ApiClient.post(
        ApiUrls.logout,
        body: fcmToken != null ? {"token": fcmToken} : null,
        requireAuth: true,
      );

      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Logout Error: $e");
      return false;
    }
  }

  static Future<List<dynamic>?> getMyBills() async {
    try {
      final res = await ApiClient.get(
        ApiUrls.myBills,
        requireAuth: true,
      );
      print("GET MY BILLS STATUS => ${res.statusCode}");
      print("GET MY BILLS BODY => ${res.body}");
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return null;
    } catch (e) {
      print("Get My Bills Error: $e");
      return null;
    }}
  static Future<Map<String, dynamic>?> createOrder({required double amount, required int billId}) async {
    try {
      final res = await ApiClient.post(
        ApiUrls.createOrder,
        body: {
          "amount": amount.toInt(),
          "currency": "INR",
          "bill_id": billId
        },
        requireAuth: true,
      );
      print("CREATE ORDER STATUS => ${res.statusCode}");
      print("CREATE ORDER BODY => ${res.body}");
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return null;
    } catch (e) {
      print("Create Order Error: $e");
      return null;
    }
  }
  static Future<bool> verifyPayment({
    required int billId,
   
    required String orderId,
  
  }) async {
    try {
      final res = await ApiClient.post(
        ApiUrls.verifyPayment,
        body: {
          "bill_id": billId,
         
          "order_id": orderId,
        
        },
        requireAuth: true,
      );
      print("VERIFY PAYMENT STATUS => ${res.statusCode}");
      print("VERIFY PAYMENT BODY => ${res.body}");
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Verify Payment Error: $e");
      return false;
    }
  }
}