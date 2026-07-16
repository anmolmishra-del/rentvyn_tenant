// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:ui';

// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// class AgreementService {
//   /// Download PDF with Bearer Token
//   Future<File> downloadPdf({
//     required String url,
//     required String token,
//   }) async {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode != 200) {
//       throw Exception(
//         "Failed to download PDF (${response.statusCode})",
//       );
//     }

//     final directory = await getApplicationDocumentsDirectory();

//     final file = File("${directory.path}/agreement.pdf");

//     await file.writeAsBytes(response.bodyBytes);

//     return file;
//   }

//   /// Embed Signature into PDF
//   Future<File> embedSignature({
//     required File pdfFile,
//     required ui.Image signatureImage,
//   }) async {
//     final pdfBytes = await pdfFile.readAsBytes();

//     final document = PdfDocument(inputBytes: pdfBytes);

//     final byteData = await signatureImage.toByteData(
//       format: ui.ImageByteFormat.png,
//     );

//     if (byteData == null) {
//       throw Exception("Unable to convert signature.");
//     }

//     final bitmap = PdfBitmap(
//       byteData.buffer.asUint8List(),
//     );

//     final page = document.pages[document.pages.count - 1];

//     page.graphics.drawImage(
//       bitmap,
//       const Rect.fromLTWH(
//         330,
//         650,
//         160,
//         60,
//       ),
//     );

//     final bytes = await document.save();

//     document.dispose();

//     final directory = await getApplicationDocumentsDirectory();

//     final signedPdf = File(
//       "${directory.path}/signed_agreement.pdf",
//     );

//     await signedPdf.writeAsBytes(bytes);

//     return signedPdf;
//   }

//   /// Upload Signed PDF with Bearer Token
//   Future<bool> uploadSignedPdf({
//     required File file,
//     required String apiUrl,
//     required String token,
//     String fieldName = "file",
//   }) async {
//     final request = http.MultipartRequest(
//       "POST",
//       Uri.parse(apiUrl),
//     );

//     request.headers.addAll({
//       "Authorization": "Bearer $token",
//     });

//     request.files.add(
//       await http.MultipartFile.fromPath(
//         fieldName,
//         file.path,
//       ),
//     );

//     final response = await request.send();

//     return response.statusCode == 200;
//   }
// }