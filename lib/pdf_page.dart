import 'package:flutter/material.dart';

import '../helper/pdf_helper.dart';
import '../helper/pdf_invoice_helper.dart';
import '../main.dart';
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
  final _customerAddressController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  final _itemUnitPriceController = TextEditingController();
  final _itemVatController = TextEditingController();

  List<InvoiceItem> items = [];
  bool isItemFormVisible = false;  // To toggle item input fields visibility

  @override
  void dispose() {
    _supplierNameController.dispose();
    _supplierAddressController.dispose();
    _customerNameController.dispose();
    _customerAddressController.dispose();
    _itemDescriptionController.dispose();
    _itemQuantityController.dispose();
    _itemUnitPriceController.dispose();
    _itemVatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color.fromARGB(66, 196, 194, 194),
    appBar: AppBar(
      centerTitle: true,
    ),
    body: SingleChildScrollView( // Make the content scrollable
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TitleWidget(
              icon: Icons.picture_as_pdf,
              text: 'Generate Invoice',
            ),
            const SizedBox(height: 48),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Supplier Details
                  TextFormField(
                    controller: _supplierNameController,
                    decoration: const InputDecoration(
                      labelText: 'Supplier Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter supplier name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _supplierAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Supplier Address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter supplier address';
                      }
                      return null;
                    },
                  ),
                  // Customer Details
                  TextFormField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter customer name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _customerAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter customer address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Toggle Item Input Form Visibility
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Item Details'),
                      IconButton(
                        icon: Icon(isItemFormVisible
                            ? Icons.add
                            : Icons.add),
                        onPressed: () {
                          setState(() {
                            isItemFormVisible = !isItemFormVisible;
                          });
                        },
                      ),
                    ],
                  ),
                  if (isItemFormVisible) ...[
                    // Item Details (Add Item Inputs)
                    TextFormField(
                      controller: _itemDescriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Item Description',
                      ),
                    ),
                    TextFormField(
                      controller: _itemQuantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _itemUnitPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Price',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _itemVatController,
                      decoration: const InputDecoration(
                        labelText: 'VAT (%)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final item = InvoiceItem(
                            description: _itemDescriptionController.text,
                            date: DateTime.now(),
                            quantity: int.tryParse(_itemQuantityController.text) ?? 1,
                            unitPrice: double.tryParse(_itemUnitPriceController.text) ?? 0.0,
                            vat: double.tryParse(_itemVatController.text) ?? 0.0,
                          );
                          setState(() {
                            items.add(item);
                            _itemDescriptionController.clear();
                            _itemQuantityController.clear();
                            _itemUnitPriceController.clear();
                            _itemVatController.clear();
                          });
                        }
                      },
                      child: const Text('Add Item'),
                    ),
                  ],

                  // Display Added Items with a Delete Option
                  const SizedBox(height: 16),
                  if (items.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Added Items:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...items.asMap().entries.map(
                              (entry) => ListTile(
                            title: Text(entry.value.description),
                            subtitle: Text('Qty: ${entry.value.quantity}, Price: ${entry.value.unitPrice}, VAT: ${entry.value.vat}%'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  items.removeAt(entry.key);
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),

                  // Generate PDF Button
                  const SizedBox(height: 16),
                  ButtonWidget(
                    text: 'Generate PDF',
                    onClicked: () async {
                      final date = DateTime.now();
                      final dueDate = date.add(const Duration(days: 7));

                      final invoice = Invoice(
                        supplier: Supplier(
                          name: _supplierNameController.text,
                          address: _supplierAddressController.text,
                          paymentInfo: '', // Optional field, empty if not needed
                        ),
                        customer: Customer(
                          name: _customerNameController.text,
                          address: _customerAddressController.text,
                        ),
                        info: InvoiceInfo(
                          date: date,
                          dueDate: dueDate,
                          description: 'Invoice Description',
                          number: '${DateTime.now().year}-9999',
                        ),
                        items: items,
                      );

                      final pdfFile = await PdfInvoicePdfHelper.generate(invoice);

                      PdfHelper.openFile(pdfFile);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
