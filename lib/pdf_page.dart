import 'package:flutter/material.dart';
import '../helper/pdf_helper.dart';
import '../helper/pdf_invoice_helper.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../widget/button_widget.dart';
import '../widget/title_widget.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  final _formKey = GlobalKey<FormState>();
  final _supplierNameController = TextEditingController();
  final _supplierAddressController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  final _itemUnitPriceController = TextEditingController();

  List<InvoiceItem> items = [];
  bool isItemFormVisible = false;
  int invoiceNumber = 1;

  @override
  void dispose() {
    _supplierNameController.dispose();
    _supplierAddressController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _itemDescriptionController.dispose();
    _itemQuantityController.dispose();
    _itemUnitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Generate Invoice'),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const TitleWidget(
              icon: Icons.picture_as_pdf,
              text: 'Generate Invoice',
              iconColor: Colors.blue,
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Supplier Details'),
                  _buildTextField(_supplierNameController, 'Supplier Name'),
                  _buildTextField(_supplierAddressController, 'Supplier Address'),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Customer Details'),
                  _buildTextField(_customerNameController, 'Customer Name'),
                  _buildTextField(_customerPhoneController, 'Customer Phone', keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Item Details'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Item',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(
                          isItemFormVisible ? Icons.remove_circle : Icons.add_circle,
                          color: Colors.blue.shade700,
                        ),
                        onPressed: () {
                          setState(() {
                            isItemFormVisible = !isItemFormVisible;
                          });
                        },
                      ),
                    ],
                  ),
                  if (isItemFormVisible) ...[
                    _buildTextField(_itemDescriptionController, 'Item Description'),
                    _buildTextField(_itemQuantityController, 'Quantity', keyboardType: TextInputType.number),
                    _buildTextField(_itemUnitPriceController, 'Unit Price', keyboardType: TextInputType.number),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final item = InvoiceItem(
                            description: _itemDescriptionController.text,
                            date: DateTime.now(),
                            quantity: int.tryParse(_itemQuantityController.text) ?? 1,
                            unitPrice: double.tryParse(_itemUnitPriceController.text) ?? 0.0, vat: 0.0,
                          );
                          setState(() {
                            items.add(item);
                            _itemDescriptionController.clear();
                            _itemQuantityController.clear();
                            _itemUnitPriceController.clear();
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add Item'),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (items.isNotEmpty) ...[
                    _buildSectionTitle('Added Items'),
                    Column(
                      children: items.asMap().entries.map((entry) {
                        final item = entry.value;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(item.description),
                            subtitle: Text('Qty: ${item.quantity}, Price: ${item.unitPrice}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  items.removeAt(entry.key);
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: _generatePdf,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Generate PDF',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Future<void> _generatePdf() async {
    if (_formKey.currentState?.validate() ?? false) {
      final date = DateTime.now();
      final invoice = Invoice(
        supplier: Supplier(
          name: _supplierNameController.text,
          address: _supplierAddressController.text,
          paymentInfo: '',
        ),
        customer: Customer(
          name: _customerNameController.text,
          phone: _customerPhoneController.text, address: '',
        ),
        info: InvoiceInfo(
          date: date,
          description: 'Invoice Description',
          number: 'INV-${invoiceNumber++}', dueDate: date.add(const Duration(days: 7)),
        ),
        items: items,
      );

      final pdfFile = await PdfInvoicePdfHelper.generate(invoice);
      PdfHelper.openFile(pdfFile);
    }
  }
}
