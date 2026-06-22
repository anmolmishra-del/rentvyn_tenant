class ApiUrls {
  // 🔐 AUTH BASE
  static const authBase =
      "https://suppositionless-geralyn-jovially.ngrok-free.dev";

  static const ownerBase =
      "https://suppositionless-geralyn-jovially.ngrok-free.dev/tenant";

  static const sendOtp = "$authBase/auth/tenant/send-otp";
  static const verifyOtp = "$authBase/auth/tenant/verify-otp";

  static const String saveFcmToken = "$authBase/token/save_token";
  static const logout = "$authBase/auth/tenant/logout";
  
 
static const complaints ="$authBase/complaints/";
static const complaintTypes ="$authBase/complaints/types";
static String tenantComplaints(int tenantId,) => "$authBase/complaints/tenant/$tenantId";
static String updateComplaint(int id, ) =>"$authBase/complaints/$id";
static String deleteComplaint(int id,) =>"$authBase/complaints/$id";
}