import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

import '../utils/localization_manager.dart';
 // Import the localization manager

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key, required String languageCode});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  bool isPrimaryUnitSelected = false;
  bool isTaxIncluded = true;
  String? selectedUnit = 'PCS';
  DateTime? selectedDate;
  File? _imageFile;

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController openingStockController = TextEditingController();
  final TextEditingController lowStockAlertController = TextEditingController();

  // Function to pick image from camera
  Future<void> _pickImage() async {
    // Check and request camera permission if necessary
    if (await Permission.camera.request().isGranted) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizationManager.getString('camera_permission_required'))),
      );
    }
  }

  // Function to pick date
  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime initialDate = selectedDate ?? currentDate;
    DateTime firstDate = DateTime(currentDate.year - 5);
    DateTime lastDate = DateTime(currentDate.year + 5);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            hintColor: Colors.black,
            colorScheme: ColorScheme.light(primary: Colors.blue),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Save item and navigate to item screen
  void _saveItem() {
    if (salePriceController.text.isNotEmpty &&
        purchasePriceController.text.isNotEmpty &&
        itemNameController.text.isNotEmpty) {
      Navigator.pop(context, {
        'itemName': itemNameController.text,
        'photo': _imageFile?.path ?? '', // Save the image path if available
        'salePrice': salePriceController.text,
        'purchasePrice': purchasePriceController.text,
        'openingStock': openingStockController.text,
        'lowStockAlert': lowStockAlertController.text,
        'selectedDate': selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : 'Not selected',
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizationManager.getString('please_fill_fields'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(LocalizationManager.getString('add_item'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Name and Photo Upload
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocalizationManager.getString('item_name'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: itemNameController,
                    decoration: InputDecoration(
                      hintText: LocalizationManager.getString('enter_item_name'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(LocalizationManager.getString('upload_photo'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.camera_alt, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(LocalizationManager.getString('capture_photo'), style: const TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              // Sale Price and Purchase Price
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocalizationManager.getString('sale_price'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        TextField(
                          controller: salePriceController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.currency_rupee),
                            border: OutlineInputBorder(),
                            hintText: 'Enter Sale Price',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocalizationManager.getString('purchase_price'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        TextField(
                          controller: purchasePriceController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.currency_rupee),
                            border: OutlineInputBorder(),
                            hintText: 'Enter Purchase Price',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Opening Stock and Low Stock Alert
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocalizationManager.getString('opening_stock'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        TextField(
                          controller: openingStockController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Opening Stock',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocalizationManager.getString('low_stock_alert'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        TextField(
                          controller: lowStockAlertController,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.notifications),
                            border: OutlineInputBorder(),
                            hintText: 'Set Low Stock Alert',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Selector
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocalizationManager.getString('as_of_date'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            selectedDate == null
                                ? LocalizationManager.getString('select_date')
                                : DateFormat('dd/MM/yyyy').format(selectedDate!),
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 330),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveItem,
                  child: Text(LocalizationManager.getString('save_item'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 120),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
