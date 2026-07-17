import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class RentalAgreementPage extends StatelessWidget {
  final int tenantId;
  final String token;

  const RentalAgreementPage({
    super.key,
    required this.tenantId,
    required this.token,
  });

  Future<void> _downloadPdf(BuildContext context) async {
    try {
      final url =
          "https://suppositionless-geralyn-jovially.ngrok-free.dev/owner/tenants/$tenantId/agreement";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();

        final file = File(
          "${directory.path}/RentalAgreement.pdf",
        );

        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "PDF downloaded successfully\n${file.path}",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Download failed (${response.statusCode})",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final url =
        "https://suppositionless-geralyn-jovially.ngrok-free.dev/owner/tenants/$tenantId/agreement";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rental Agreement"),
      
      ),
      // body: SfPdfViewer.network(
      //   url,
      //   headers: {
      //     "Authorization": "Bearer $token",
      //   },
      //   canShowPaginationDialog: true,
      //   canShowScrollHead: true,
      //   enableDoubleTapZooming: true,
      //   pageSpacing: 8,
      // ),
      body: Column(
  children: [
    Expanded(
      child: SfPdfViewer.network(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
        canShowPaginationDialog: true,
        canShowScrollHead: true,
        enableDoubleTapZooming: true,
        pageSpacing: 8,
      ),
    ),

    SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              onPressed: () => _downloadPdf(context),
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text(
                "Download PDF",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ],
),
    );
  }
}