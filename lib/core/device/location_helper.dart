import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationHelper {
  static Future<Map<String, dynamic>> getLocationAndCity() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _defaultLocation();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _defaultLocation();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _defaultLocation();
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low); // Use low accuracy for speed
          
      String city = "Unknown";
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          city = placemarks.first.locality ?? placemarks.first.subAdministrativeArea ?? "Unknown";
          if (city.isEmpty) {
            city = "Unknown";
          }
        }
      } catch (e) {
        print("Geocoding Error: $e");
      }

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'city': city,
      };
    } catch (e) {
      print("Location Error: $e");
      return _defaultLocation();
    }
  }

  static Map<String, dynamic> _defaultLocation() {
    return {
      'latitude': 0.0,
      'longitude': 0.0,
      'city': 'Unknown',
    };
  }
}
