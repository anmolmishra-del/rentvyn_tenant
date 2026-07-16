// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rentvyn_tenant/features/agreement_details_page/service/service_page.dart';
// import 'package:rentvyn_tenant/features/agreement_details_page/state/state.dart';
// import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

// class AgreementCubit extends Cubit<AgreementState> {
//   final AgreementService service;

//   AgreementCubit(this.service) : super(const AgreementState());

//   /// Download PDF
//   Future<void> loadPdf({
//     required String pdfUrl,
//     required String token,
//   }) async {
//     try {
//       emit(state.copyWith(
//         isLoading: true,
//         error: null,
//       ));

//       final file = await service.downloadPdf(
//         url: pdfUrl,
//         token: token,
//       );

//       emit(state.copyWith(
//         isLoading: false,
//         isPdfLoaded: true,
//         pdfFile: file,
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       ));
//     }
//   }

//   /// Save Signature into PDF
//   Future<void> saveSignature(
//     GlobalKey<SfSignaturePadState> signatureKey,
//   ) async {
//     try {
//       emit(state.copyWith(
//         isLoading: true,
//         error: null,
//       ));

//       final ui.Image signature =
//           await signatureKey.currentState!.toImage();

//       final signedPdf = await service.embedSignature(
//         pdfFile: state.pdfFile!,
//         signatureImage: signature,
//       );

//       emit(state.copyWith(
//         isLoading: false,
//         isSignatureSaved: true,
//         signedPdfFile: signedPdf,
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       ));
//     }
//   }

//   /// Upload Signed PDF
//   Future<void> uploadSignedPdf({
//     required String apiUrl,
//     required String token,
//   }) async {
//     try {
//       emit(state.copyWith(
//         isUploading: true,
//       ));

//       await service.uploadSignedPdf(
//         file: state.signedPdfFile!,
//         apiUrl: apiUrl,
//         token: token,
//       );

//       emit(state.copyWith(
//         isUploading: false,
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         isUploading: false,
//         error: e.toString(),
//       ));
//     }
//   }

//   void clearError() {
//     emit(state.copyWith(error: null));
//   }
// }