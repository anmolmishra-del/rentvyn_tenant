import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceHelper {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;

      return {
        "device_name": android.model,
        "brand": android.brand,
        "device_id": android.id,
        "platform": "android",
        "os_version": android.version.release,
      };
    }

    if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;

      return {
        "device_name": ios.name,
        "brand": "Apple",
        "device_id": ios.identifierForVendor,
        "platform": "ios",
        "os_version": ios.systemVersion,
      };
    }

    return {};
  }
}