class ApiUrls {
  // 🔐 AUTH BASE
  static const authBase =
      "https://suppositionless-geralyn-jovially.ngrok-free.dev";

  static const ownerBase =
      "https://suppositionless-geralyn-jovially.ngrok-free.dev/tenant";

  static const sendOtp = "$authBase/auth/tenant/send-otp";
  static const verifyOtp = "$authBase/auth/tenant/verify-otp";

  static const String saveFcmToken = "$authBase/token/save_token";
  
}
