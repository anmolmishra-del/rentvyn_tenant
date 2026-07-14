import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';
import 'package:rentvyn_tenant/core/services/api_client.dart';
import 'package:rentvyn_tenant/core/services/api_urls.dart';
import 'package:rentvyn_tenant/features/roommate/model/model.dart';

class RoommateService {
  static Future<List<RoommateModel>> getRoommates(int roomId) async {
    try {
      final token = await AuthStorage.getToken();
print(token);

      print("========== ROOMMATE API ==========");
      print("ROOM ID => $roomId");
      print("URL => ${ApiUrls.ownerTenants}");
      print("TOKEN => $token");

      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      // final response = await http.get(
      //   Uri.parse(ApiUrls.ownerTenants),
      //   headers: {
      //     "accept": "application/json",
      //     "Authorization": "Bearer $token",
      //   },
      // );
        final res = await ApiClient.get(
        ApiUrls.tenantRoomTenants(roomId),
        requireAuth: true,
      );

    
      print(
        "GET COMPLAINT STATUS => ${res.statusCode}",
      );
      print(
        "GET COMPLAINT BODY => ${res.body}",
      );
      if (res.statusCode != 200) {
        throw Exception(
          "API Error ${res.statusCode}: ${res.body}",
        );
      }

      final List<dynamic> data = jsonDecode(res.body);

      // Filter only same room tenants
      final roomData = data.where((e) {
        return e["room"] != null && e["room"]["id"] == roomId;
      }).toList();

      print("TOTAL ROOMMATES => ${roomData.length}");

      return roomData
          .map((e) => RoommateModel.fromJson(e))
          .toList();
    } catch (e, s) {
      print("RoommateService Error => $e");
      print(s);
      rethrow;
    }
  }
}