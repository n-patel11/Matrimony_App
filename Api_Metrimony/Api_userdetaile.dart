import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ApiUserdetaile extends StatelessWidget {
  final Map userMap;

  const ApiUserdetaile({super.key, required this.userMap});

  String _getAvatar() {
    return userMap['Column_gender'].toString().toLowerCase() == "female"
        ? "assets/img_5.png"
        : "assets/img_4.png";
  }

  Future<void> _generateAndPrintPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  "User Details",
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              _buildPdfText("Name", userMap['Column_name']),
              _buildPdfText("Date of Birth", userMap['Column_dob']),
              _buildPdfText("Age", userMap['Column_age']),
              _buildPdfText("Email", userMap['Column_email']),
              _buildPdfText("Phone", userMap['Column_phone']),
              _buildPdfText("Gender", userMap['Column_gender']),
              _buildPdfText("City", userMap['Column_city']),
              _buildPdfText("Height", userMap['Column_height']),
              _buildPdfText("Weight", userMap['Column_weight']),
              _buildPdfText("Cast", userMap['Column_cast']),
              _buildPdfText("Hobbies", userMap['Column_hobbies']),
            ],
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/UserDetails.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildPdfText(String label, dynamic value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Text(
        "$label: ${value ?? 'Not Available'}",
        style: pw.TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("User Details"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generateAndPrintPDF(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildInfoCard(Icons.person, "Name", userMap['Column_name'] ?? "Not Available"),
            _buildInfoCard(Icons.cake, "Date of Birth", userMap['Column_dob'] ?? "Not Available"),
            _buildInfoCard(Icons.event, "Age", userMap['Column_age'] ?? "Not Available"),
            _buildInfoCard(Icons.email, "Email", userMap['Column_email'] ?? "Not Available"),
            _buildInfoCard(Icons.phone, "Phone", userMap['Column_phone'] ?? "Not Available"),
            _buildInfoCard(Icons.transgender, "Gender", userMap['Column_gender'] ?? "Not Available"),
            _buildInfoCard(Icons.location_city, "City", userMap['Column_city'] ?? "Not Available"),
            _buildInfoCard(Icons.height, "Height", userMap['Column_height'] ?? "Not Available"),
            _buildInfoCard(Icons.fitness_center, "Weight", userMap['Column_weight'] ?? "Not Available"),
            _buildInfoCard(Icons.cast, "Cast", userMap['Column_cast'] ?? "Not Available"),
            _buildInfoCard(Icons.sports, "Hobbies", userMap['Column_hobbies'] ?? "Not Available"),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage(_getAvatar()),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: Icon(icon, color: Color(0xFF5B52A3)),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(value, style: TextStyle(color: Colors.grey[700])),
        ),
      ),
    );
  }
}



















// import 'package:flutter/material.dart';
//
// class ApiUserdetaile extends StatelessWidget {
//   final Map userMap;
//
//   const ApiUserdetaile({super.key, required this.userMap});
//
//   String _getAvatar() {
//     return userMap['Column_gender'].toString().toLowerCase() == "female"
//         ? "assets/img_5.png"
//         : "assets/img_4.png";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("User Details"),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildProfileHeader(),
//             const SizedBox(height: 20),
//             _buildInfoCard(Icons.person, "Name", userMap['Column_name'] ?? "Not Available"),
//             _buildInfoCard(Icons.cake, "Date of Birth", userMap['Column_dob'] ?? "Not Available"),
//             _buildInfoCard(Icons.event, "Age", userMap['Column_age'] ?? "Not Available"),
//             _buildInfoCard(Icons.email, "Email", userMap['Column_email'] ?? "Not Available"),
//             _buildInfoCard(Icons.phone, "Phone", userMap['Column_phone'] ?? "Not Available"),
//             _buildInfoCard(Icons.transgender, "Gender", userMap['Column_gender'] ?? "Not Available"),
//             _buildInfoCard(Icons.location_city, "City", userMap['Column_city'] ?? "Not Available"),
//             _buildInfoCard(Icons.height, "Height", userMap['Column_height'] ?? "Not Available"),
//             _buildInfoCard(Icons.fitness_center, "Weight", userMap['Column_weight'] ?? "Not Available"),
//             _buildInfoCard(Icons.cast, "Cast", userMap['Column_cast'] ?? "Not Available"),
//             _buildInfoCard(Icons.sports, "Hobbies", userMap['Column_hobbies'] ?? "Not Available"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 60,
//             backgroundImage: AssetImage(_getAvatar()),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoCard(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: ListTile(
//           leading: Icon(icon, color: Color(0xFF5B52A3)),
//           title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//           subtitle: Text(value, style: TextStyle(color: Colors.grey[700])),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
