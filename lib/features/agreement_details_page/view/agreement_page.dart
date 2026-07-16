// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rentvyn_tenant/features/agreement_details_page/cubit/cubit_page.dart';
// import 'package:rentvyn_tenant/features/agreement_details_page/service/service_page.dart';
// import 'package:rentvyn_tenant/features/agreement_details_page/state/state.dart';
// import 'package:rentvyn_tenant/features/auth/models/owner_model.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

// import '../../../core/constants/app_colors.dart';


// class AgreementDetailsPage extends StatefulWidget {
// Owner? owner;
// final String pdfUrl;
//   AgreementDetailsPage({
//     super.key,
//     this.owner,
//     required this.pdfUrl
//   });

//   @override
//   State<AgreementDetailsPage> createState() =>
//       _AgreementDetailsPageState();
// }

// class _AgreementDetailsPageState
//     extends State<AgreementDetailsPage> {
//       // bool _showSignature = false;
//       Uint8List? _signatureBytes;
//   final GlobalKey<SfSignaturePadState> _signatureKey =
//       GlobalKey<SfSignaturePadState>();

//   late AgreementCubit cubit;

//   @override
//   void initState() {
//     super.initState();

//     cubit = AgreementCubit(
//       AgreementService(),
//     );

//    cubit.loadPdf(
//   widget.pdfUrl.isNotEmpty
//       ? widget.pdfUrl
//       : "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
// );
//   }

//   @override
//   void dispose() {
//     cubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: cubit,
//       child: BlocConsumer<
//           AgreementCubit,
//           AgreementState>(
//         listener: (context, state) {
//           if (state.error != null) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(
//               SnackBar(
//                 content: Text(state.error!),
//               ),
//             );
//           }

//           if (state.isSignatureSaved) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   "Signature Saved Successfully",
//                 ),
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor:
//                 AppColors.background,
//             appBar: AppBar(
//               elevation: 0,
//               backgroundColor:
//                   Colors.white,
//               centerTitle: true,
//               title: const Text(
//                 "Rental Agreement",
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontWeight:
//                       FontWeight.bold,
//                 ),
//               ),
//               leading: IconButton(
//                 icon: const Icon(
//                   Icons
//                       .arrow_back_ios_new_rounded,
//                   color: Colors.black87,
//                 ),
//                 onPressed: () {
//                   Navigator.pop(
//                     context,
//                   );
//                 },
//               ),
//             ),
//             body: Column(
//   children: [
//     // Expanded(
//     //   child: state.pdfFile != null
//     //       ? SfPdfViewer.file(state.pdfFile!)
//     //       : const Center(
//     //           child: Text("Rental Agreement not available"),
//     //         ),
// Expanded(
//   child: Stack(
//     children: [
//       // SfPdfViewer.network(
//       //   widget.pdfUrl,

//       // ),
// SfPdfViewer.network(
//   widget.owner!.rentalAgreement.isNotEmpty
//       ? widget.owner!.rentalAgreement
//       : "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
// ),
//       if (_signatureBytes != null)
//         Positioned(
//           bottom: 80,
//           right: 30,
//           child: Image.memory(
//             _signatureBytes!,
//             width: 150,
//             height: 60,
//           ),
//         ),
//     ],
//   ),
// ),
//     Container(
//       padding: const EdgeInsets.all(16),
//       color: Colors.white,
//       child: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           height: 55,
//           child: ElevatedButton.icon(
//             onPressed: () {
//               _showSignatureBottomSheet(context);
//             },
//             icon: const Icon(Icons.draw),
//             label: const Text("Digital Signature"),
//           ),
//         ),
//       ),
//     ),
//   ],
// ));
//         },
//       ),
//     );
//   }
//   void _showSignatureBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(24),
//       ),
//     ),
//     builder: (_) {
//       return Padding(
//         padding: const EdgeInsets.all(20),
//         child: SizedBox(
//           height: 450,
//           child: Column(
//             children: [
//               const Text(
//                 "Digital Signature",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const SizedBox(height: 20),

//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: SfSignaturePad(
//                     key: _signatureKey,
//                     backgroundColor: Colors.white,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         _signatureKey.currentState?.clear();
//                       },
//                       child: const Text("Clear"),
//                     ),
//                   ),

//                   const SizedBox(width: 12),

//                   Expanded(
//                     child: ElevatedButton(
//                       // onPressed: () {
//                       //   context
//                       //       .read<AgreementCubit>()
//                       //       .saveSignature(_signatureKey);

//                       //   Navigator.pop(context);
//                       // },
// onPressed: () async {
//   final ui.Image image =
//       await _signatureKey.currentState!.toImage();

//   final byteData = await image.toByteData(
//     format: ui.ImageByteFormat.png,
//   );

//   if (byteData != null) {
//     setState(() {
//       _signatureBytes = byteData.buffer.asUint8List();
//     });
//   }

//   Navigator.pop(context);

//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(
//       content: Text("Signature Added Successfully"),
//     ),
//   );
// },
//                       child: const Text(
//                         "Save Signature",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }}