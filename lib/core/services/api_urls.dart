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
// static const String notices = "$authBase/notices/";
static String hostelNotices(int hostelId) => "$authBase/complaints/notice_boards/$hostelId";
static String ownerHostelTenants(int hostelId) =>"$authBase/owner/hostels/$hostelId/tenants";
static String roomTenants(int roomId) => "$authBase/owner/rooms/$roomId/tenants"; 
//  static String tenantRoomTenants(int roomId) => "$authBase/tenant/rooms/$roomId/tenants";
static const String ownerTenants = "$authBase/owner/tenants";
static String tenantRoomTenants(int roomId) =>"$authBase/tenant/rooms/$roomId/tenants";
}