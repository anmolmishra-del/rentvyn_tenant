import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';
import 'package:rentvyn_tenant/core/constants/device_info.dart';
import 'package:rentvyn_tenant/core/device/location_helper.dart';
import 'package:rentvyn_tenant/features/auth/cubit/auth_service.dart';
import 'package:rentvyn_tenant/features/auth/models/owner_model.dart';
import 'package:rentvyn_tenant/features/auth/state/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  Timer? _timer;
  String? phone;
  LoginCubit() : super(LoginState());

  /// Resets cubit back to initial state (phone entry screen).
  void reset() {
    _timer?.cancel();
    emit(LoginState());
  }

  void sendOtp(String phone) async {
    try {
      this.phone = phone;

      emit(state.copyWith(isLoading: true, error: null));

      final success = await AuthService.sendOtp(phone);

      if (success) {
        emit(state.copyWith(isLoading: false, otpSent: true, timer: 30));
        startTimer();
      } else {
        emit(state.copyWith(isLoading: false, error: "Failed to send OTP"));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadUser() async {
    final user = await AuthStorage.getOwner();

    if (user != null) {
      emit(state.copyWith(owner: user, isVerified: true));
    }
  }

  void updateOwner(Owner owner) {
    emit(state.copyWith(owner: owner));
  }

  void resendOtp(String phone) {
    sendOtp(phone);
  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timer <= 0) {
        timer.cancel();

        emit(state.copyWith(timer: 0));

        return;
      }

      emit(state.copyWith(timer: state.timer - 1));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void verifyOtp(String otp, String phone) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final res = await AuthService.verifyOtp(phone, otp);

      if (res != null) {
        final owner = Owner.fromJson(res);

        await AuthStorage.saveAuth(owner.accessToken ?? "", owner);

        print("Access Token: ${owner.accessToken}");

        print("Owner Name: ${owner.firstName}");

        print("Plan: ${owner.plan?.name}");

        print("Subscriptions: ${owner.subscriptions.length}");

        // Mark user as verified and stop loading immediately so UI can
        // proceed. Save FCM token and other side-effects asynchronously
        // so they don't block navigation or keep the button loading.
        emit(state.copyWith(isLoading: false, isVerified: true, owner: owner));

        // Perform FCM/device/location saving in background.
        () async {
          try {
            final fcmToken = await FirebaseMessaging.instance.getToken();

            if (fcmToken != null) {
              final deviceInfo = await DeviceHelper.getDeviceInfo();
              final locationInfo = await LocationHelper.getLocationAndCity();

              await saveFcmToken(
                fcmToken,
                owner.id,
                deviceInfo,
                locationInfo['city'],
                locationInfo['latitude'],
                locationInfo['longitude'],
              );
            }
          } catch (e) {
            print("Background FCM save error: $e");
          }
        }();
      } else {
        emit(state.copyWith(isLoading: false, error: "Invalid OTP"));
      }
    } catch (e) {
      print("Verify OTP Error: $e");

      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> saveFcmToken(String token, int userId, final deviceInfo, String city, double latitude, double longitude) async {
    try {
      final success = await AuthService.saveFcmToken(
        token: token,
        userId: userId,
        deviceInfo: deviceInfo,
        city: city,
        latitude: latitude,
        longitude: longitude,
      );

      if (success) {
        print("✅ FCM token saved");
      } else {
        print("❌ Failed to save FCM token");
      }
    } catch (e) {
      print("❌ Error saving FCM token: $e");
    }
  }
}
