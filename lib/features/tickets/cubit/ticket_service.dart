import 'dart:convert';

import 'package:rentvyn_tenant/features/tickets/models/ticket_model.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/api_urls.dart';

class TicketsService {
  // =========================
  // GET TENANT COMPLAINTS
  // =========================

  static Future<List<Complaint>> getTenantTickets(
    int tenantId,
  ) async {
    try {
      final res = await ApiClient.get(
        ApiUrls.tenantComplaints(tenantId),
        requireAuth: true,
      );

      print(
        "GET COMPLAINT STATUS => ${res.statusCode}",
      );
      print(
        "GET COMPLAINT BODY => ${res.body}",
      );

      if (res.statusCode == 200) {
        final List data =
            jsonDecode(res.body);

        return data
            .map(
              (e) => Complaint.fromJson(e),
            )
            .toList();
      }

      return [];
    } catch (e) {
      print(
        "GET COMPLAINT ERROR => $e",
      );
      return [];
    }
  }

  // =========================
  // CREATE COMPLAINT
  // =========================

  static Future<bool> createComplaint({
    required int hostelId,
    required int tenantId,
    required int ownerId,
    required int complaintTypeId,
    required String description,
    String priority = "normal",
  }) async {
    try {
      final body = {
        "hostel_id": hostelId,
        "tenant_id": tenantId,
        "owner_id": ownerId,
        "complaint_type_id":
            complaintTypeId,
        "description": description,
        "status": "open",
        "priority": priority,
      };

      print(
        "CREATE BODY => $body",
      );

      final res = await ApiClient.post(
        ApiUrls.complaints,
        requireAuth: true,
        body: body,
      );

      print(
        "CREATE STATUS => ${res.statusCode}",
      );

      print(
        "CREATE RESPONSE => ${res.body}",
      );

      return res.statusCode == 200 ||
          res.statusCode == 201;
    } catch (e) {
      print(
        "CREATE COMPLAINT ERROR => $e",
      );
      return false;
    }
  }

  // =========================
  // UPDATE COMPLAINT
  // =========================

  static Future<bool> updateComplaint({
    required int complaintId,
    required String description,
  }) async {
    try {
      final res = await ApiClient.put(
        ApiUrls.updateComplaint(
          complaintId,
        ),
        requireAuth: true,
        body: {
          "description": description,
        },
      );

      print(
        "UPDATE STATUS => ${res.statusCode}",
      );

      print(
        "UPDATE RESPONSE => ${res.body}",
      );

      return res.statusCode == 200;
    } catch (e) {
      print(
        "UPDATE ERROR => $e",
      );
      return false;
    }
  }
static Future<List<ComplaintType>>
    getComplaintTypes() async {
  try {
    final res = await ApiClient.get(
      ApiUrls.complaintTypes,
      requireAuth: true,
    );

    print(
      "TYPE STATUS => ${res.statusCode}",
    );

    print(
      "TYPE BODY => ${res.body}",
    );

    if (res.statusCode == 200) {
      final List data =
          jsonDecode(res.body);

      return data
          .map(
            (e) => ComplaintType.fromJson(e),
          )
          .toList();
    }

    return [];
  } catch (e) {
    print(
      "TYPE ERROR => $e",
    );
    return [];
  }
}
  // =========================
  // DELETE COMPLAINT
  // =========================

  static Future<bool> deleteComplaint(
    int complaintId,
  ) async {
    try {
      final res = await ApiClient.delete(
        ApiUrls.deleteComplaint(
          complaintId,
        ),
        requireAuth: true,
      );

      print(
        "DELETE STATUS => ${res.statusCode}",
      );

      return res.statusCode == 200;
    } catch (e) {
      print(
        "DELETE ERROR => $e",
      );
      return false;
    }
  }
}