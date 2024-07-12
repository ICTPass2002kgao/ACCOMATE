// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show NetworkAssetBundle;
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ViewContract extends StatefulWidget {
//   final Map<String, dynamic> studentApplicationData;

//   const ViewContract({Key? key, required this.studentApplicationData}) : super(key: key);

//   @override
//   _ViewContractState createState() => _ViewContractState();
// }

// class _ViewContractState extends State<ViewContract> {
//   PdfDocument? _pdfDocument;
//   Uint8List? _pdfBytes;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadPdf();
//   }

//   Future<void> _loadPdf() async {
//     final ByteData data = await NetworkAssetBundle(Uri.parse(widget.studentApplicationData['contract'] ??
//         'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf')).load("");
//     _pdfBytes = data.buffer.asUint8List();
//     _pdfDocument = PdfDocument(inputBytes: _pdfBytes);
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _downloadPdf() async {
//     String pdfUrl = widget.studentApplicationData['contract'] ??widget.studentApplicationData['signedContract'];
//     await canLaunch(pdfUrl)
//         ? await launch(pdfUrl)
//         : throw 'Could not launch $pdfUrl';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[100],
//       appBar: AppBar(
//         title: Text(
//           '${widget.studentApplicationData['name'] ?? 'NaN'}\'s Contract',
//         ),
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.blue,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: _downloadPdf,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SfPdfViewer.memory(
//               _pdfBytes!,
//               scrollDirection: PdfScrollDirection.vertical,
//             ),
//     );
//   }
// }
