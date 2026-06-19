import 'package:field_star_customer_app/model/tech_model.dart';
import 'package:field_star_customer_app/service/raise_complaint_db.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoicePaymentPage extends StatefulWidget {
  final String ticketId;
  final String technicianId;
  final String technicianName;
  final String equipment;
  final String serviceDate;

  const InvoicePaymentPage({
    super.key,
    required this.ticketId,
    required this.technicianId,
    required this.technicianName,
    required this.equipment,
    required this.serviceDate,
  });

  @override
  State<InvoicePaymentPage> createState() => _InvoicePaymentPageState();

  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    );
  }

  static Widget _invoiceRow(
    String title,
    String amount, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isBold ? Colors.black : Colors.blueGrey,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isBold ? 16 : 13,
              color: Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _paymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.deepOrange : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFF3F4F6),
            child: Icon(icon, color: Colors.black87, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InvoicePaymentPageState extends State<InvoicePaymentPage> {
  final repo = RaiseComplaintDb();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invoice & Payment",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder<TechModel?>(
              future: repo.fetchTechDetails(widget.ticketId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('Technician not assigned'));
                }

                final techDetails = snapshot.data!;
                return Text(
                  'Technician ID: ${techDetails.techId}',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 11),
                );
              },
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            backgroundColor: const Color(0xFFF3F4F6),
            child: IconButton(
              icon: const Icon(Icons.download, color: Colors.black87, size: 20),
              onPressed: downloadReceipt,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Invoice Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: InvoicePaymentPage._cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Field Star Services",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Paid",
                          style: TextStyle(
                            color: Color(0xFF059669),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    "Invoice #INV-2451",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                  ),
                  const Text(
                    "Date: May 25, 2026",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 11),
                  ),

                  const Divider(height: 28),

                  const Text(
                    "Bill To:",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Grand Hyatt, Mumbai",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Off Western Express Highway",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                  ),

                  const SizedBox(height: 18),
                  InvoicePaymentPage._invoiceRow(
                    "Service Inspection Fee",
                    "Rs. 500",
                  ),
                  InvoicePaymentPage._invoiceRow(
                    "Temperature Controller Replacement",
                    "Rs. 3200",
                  ),
                  InvoicePaymentPage._invoiceRow(
                    "Thermostat Calibration",
                    "Rs. 800",
                  ),
                  InvoicePaymentPage._invoiceRow(
                    "Parts & Materials",
                    "Rs. 1200",
                  ),

                  const Divider(height: 26),

                  InvoicePaymentPage._invoiceRow("Subtotal", "Rs. 5700"),
                  InvoicePaymentPage._invoiceRow("GST (18%)", "Rs. 1026"),

                  const SizedBox(height: 8),
                  InvoicePaymentPage._invoiceRow(
                    "Total Amount",
                    "Rs. 6726",
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Payment Success
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: InvoicePaymentPage._cardDecoration(),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFFD1FAE5),
                        child: Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment Successful",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Paid via UPI on May 25, 2026 at 2:30 PM",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Transaction ID:",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              "TXN20260525143045",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Payment Method:",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              "UPI - fieldstar@paytm",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Other Payment Methods
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: InvoicePaymentPage._cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Other Payment Methods",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 14),

                  InvoicePaymentPage._paymentMethod(
                    icon: Icons.qr_code_2,
                    title: "Scan QR Code",
                    subtitle: "Pay using any UPI app",
                    isSelected: true,
                  ),

                  const SizedBox(height: 12),

                  InvoicePaymentPage._paymentMethod(
                    icon: Icons.credit_card,
                    title: "Cash Payment",
                    subtitle: "Pay to technician directly",
                    isSelected: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: OutlinedButton.icon(
                onPressed: downloadReceipt,
                icon: const Icon(Icons.download, size: 18),
                label: const Text("Download"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.go(
                    '/rating',
                    extra: {
                      'ticketId': widget.ticketId,
                      'technicianId': widget.technicianId,
                      'technicianName': widget.technicianName,
                      'equipment': widget.equipment,
                      'serviceDate': widget.serviceDate,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                ),
                child: const Text(
                  "Rate Service",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //==============Download Button=====================================
  Future<void> downloadReceipt() async {
    final font = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'PAYMENT RECEIPT',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),

                pw.SizedBox(height: 25),

                pw.Text(
                  'Field Star Services',
                  style: pw.TextStyle(fontSize: 18, font: boldFont),
                ),

                pw.SizedBox(height: 10),
                pw.Text('Invoice No: INV-${widget.ticketId}'),
                pw.Text('Ticket ID: ${widget.ticketId}'),
                pw.Text('Date: May 25, 2026'),

                pw.Divider(height: 30),

                pw.Text('Bill To:', style: pw.TextStyle(font: boldFont)),
                pw.Text('Grand Hyatt, Mumbai'),
                pw.Text('Off Western Express Highway'),

                pw.SizedBox(height: 20),

                receiptRow('Service Inspection Fee', 'Rs. 500'),
                receiptRow('Temperature Controller Replacement', 'Rs. 3200'),
                receiptRow('Thermostat Calibration', 'Rs. 800'),
                receiptRow('Parts & Materials', 'Rs. 1200'),

                pw.Divider(height: 30),

                receiptRow('Subtotal', 'Rs. 5700'),
                receiptRow('GST (18%)', 'Rs. 1026'),

                pw.SizedBox(height: 10),

                receiptRow('Total Amount', 'Rs. 6726', isBold: true),

                pw.SizedBox(height: 25),

                pw.Text(
                  'Payment Status: PAID',
                  style: pw.TextStyle(font: boldFont, color: PdfColors.green),
                ),
                pw.Text('Transaction ID: TXN20260525143045'),
                pw.Text('Payment Method: UPI - fieldstar@paytm'),

                pw.SizedBox(height: 40),

                pw.Center(
                  child: pw.Text('Thank you for choosing Field Star Services'),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Receipt_${widget.ticketId}.pdf',
    );
  }

  pw.Widget receiptRow(String title, String amount, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
          pw.Text(
            amount,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
