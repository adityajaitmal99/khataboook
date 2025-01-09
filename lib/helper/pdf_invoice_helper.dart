import 'dart:io';
import 'package:khataboook/helper/pdf_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../utils.dart';
class PdfInvoicePdfHelper {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    pdf.addPage(MultiPage(
      margin: const EdgeInsets.all(20),
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoiceTable(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));
    return PdfHelper.saveDocument(name: 'invoice_${invoice.info.number}.pdf', pdf: pdf);
  }
  static Widget buildHeader(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildSupplierAddress(invoice.supplier),
          Container(
            height: 70,
            width: 70,
            child: BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: invoice.info.number,
              drawText: false,
            ),
          ),
        ],
      ),
      SizedBox(height: 1.5 * PdfPageFormat.cm),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCustomerAddress(invoice.customer),
          buildInvoiceInfo(invoice.info),
        ],
      ),
    ],
  );

  static Widget buildCustomerAddress(Customer customer) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      SizedBox(height: 4),
      Text(customer.address, style: TextStyle(fontSize: 10)),
    ],
  );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final titles = <String>['Invoice No:', 'Date:', 'Payment Terms:', 'Due Date:'];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      '${info.dueDate.difference(info.date).inDays} days',
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        return buildText(
          title: titles[index],
          value: data[index],
          width: 200,
        );
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      SizedBox(height: 4),
      Text(supplier.address, style: TextStyle(fontSize: 10)),
    ],
  );

  static Widget buildTitle(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Receipt',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      Text(
        invoice.info.description,
        style: TextStyle(fontSize: 10),
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
    ],
  );
  static Widget buildInvoiceTable(Invoice invoice) {
    final headers = ['Description', 'Date', 'Qty', 'Unit Price', 'VAT', 'Total'];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);
      return [
        item.description,
        Utils.formatDate(item.date),
        '${item.quantity}',
        '\Rs ${item.unitPrice.toStringAsFixed(2)}',
        '${(item.vat * 100).toStringAsFixed(0)}%',
        '\Rs ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellStyle: TextStyle(fontSize: 9),
      cellHeight: 25,
      columnWidths: {
        0: const FlexColumnWidth(2),
        1: const FlexColumnWidth(2),
        2: const FlexColumnWidth(1),
        3: const FlexColumnWidth(1.5),
        4: const FlexColumnWidth(1),
        5: const FlexColumnWidth(1.5),
      },
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((value, element) => value + element);
    final vat = invoice.items.fold(0.0, (sum, item) => sum + item.unitPrice * item.quantity * item.vat);
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText(title: 'Net Total:', value: Utils.formatPrice(netTotal), unite: true),
          buildText(title: 'VAT:', value: Utils.formatPrice(vat), unite: true),
          Divider(),
          buildText(
            title: 'Total Amount:',
            value: Utils.formatPrice(total),
            titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unite: true,
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      Text('Thank you for your business!', style: TextStyle(fontSize: 10)),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text(invoice.supplier.address, style: TextStyle(fontSize: 8)),
      Text('Payment Info: ${invoice.supplier.paymentInfo}', style: TextStyle(fontSize: 8)),
    ],
  );

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 10);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
