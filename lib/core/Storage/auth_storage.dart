import 'dart:convert';
import 'package:rentvyn_tenant/features/auth/models/owner_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static Future<void> saveAuth(String token, Owner owner) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", token);
    await prefs.setString("owner", jsonEncode(owner.toJson()));

    final saved = await AuthStorage.getOwner();

    String managerName = 'N/A';
    if (saved?.manager != null && saved!.manager!.isNotEmpty) {
      managerName = saved.manager![0].name;
    }

    print("Saved Manager => $managerName");

    print("Saved IsManager => ${saved?.isManager}");
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    return token != null && token.isNotEmpty;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> updateOwner(Owner owner) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("owner", jsonEncode(owner.toJson()));
  }

  static Future<Owner?> getOwner() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("owner");

    print("SAVED TENANT => $data");

    if (data != null) {
      return Owner.fromJson(jsonDecode(data));
    }

    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<int?> getHostelId() async {
    final owner = await getOwner();
    return owner?.hostelId;
  }
}
