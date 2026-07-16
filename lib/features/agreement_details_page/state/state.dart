// import 'dart:io';

// class AgreementState {
//   final bool isLoading;
//   final bool isPdfLoaded;
//   final bool isSignatureSaved;
//   final bool isUploading;
//   final String? error;
//   final File? pdfFile;
//   final File? signedPdfFile;

//   const AgreementState({
//     this.isLoading = false,
//     this.isPdfLoaded = false,
//     this.isSignatureSaved = false,
//     this.isUploading = false,
//     this.error,
//     this.pdfFile,
//     this.signedPdfFile,
//   });

//   AgreementState copyWith({
//     bool? isLoading,
//     bool? isPdfLoaded,
//     bool? isSignatureSaved,
//     bool? isUploading,
//     String? error,
//     File? pdfFile,
//     File? signedPdfFile,
//   }) {
//     return AgreementState(
//       isLoading: isLoading ?? this.isLoading,
//       isPdfLoaded: isPdfLoaded ?? this.isPdfLoaded,
//       isSignatureSaved: isSignatureSaved ?? this.isSignatureSaved,
//       isUploading: isUploading ?? this.isUploading,
//       error: error,
//       pdfFile: pdfFile ?? this.pdfFile,
//       signedPdfFile: signedPdfFile ?? this.signedPdfFile,
//     );
//   }
// }