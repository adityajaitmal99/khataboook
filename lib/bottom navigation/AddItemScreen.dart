import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../I10n/app_locale.dart';

class AddItemScreen extends StatefulWidget {
  final String languageCode;

  const AddItemScreen({super.key, required this.languageCode});

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

  Future<void> _pickImage() async {
    if (await Permission.camera.request().isGranted) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocale.getText('camera_permission_required', widget.languageCode))),
      );
    }
  }

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
            colorScheme: const ColorScheme.light(primary: Colors.blue),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
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

  void _saveItem() {
    if (salePriceController.text.isNotEmpty &&
        purchasePriceController.text.isNotEmpty &&
        itemNameController.text.isNotEmpty) {
      Navigator.pop(context, {
        'itemName': itemNameController.text,
        'photo': _imageFile?.path ?? '',
        'salePrice': salePriceController.text,
        'purchasePrice': purchasePriceController.text,
        'openingStock': openingStockController.text,
        'lowStockAlert': lowStockAlertController.text,
        'selectedDate': selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : 'Not selected',
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocale.getText('please_fill_fields', widget.languageCode))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
            AppLocale.getText('addProduct', widget.languageCode),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocale.getText('itemName', widget.languageCode),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                  TextField(
                    controller: itemNameController,
                    decoration: InputDecoration(
                      hintText: AppLocale.getText('enterItemName', widget.languageCode),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                      AppLocale.getText('uploadPhoto', widget.languageCode),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
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
                          Text(
                              AppLocale.getText('capturePhoto', widget.languageCode),
                              style: const TextStyle(color: Colors.blue)
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            AppLocale.getText('salePrice', widget.languageCode),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                        TextField(
                          controller: salePriceController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.currency_rupee),
                            border: OutlineInputBorder(),
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
                        Text(
                            AppLocale.getText('purchasePrice', widget.languageCode),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                        TextField(
                          controller: purchasePriceController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.currency_rupee),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            AppLocale.getText('openingStock', widget.languageCode),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                        TextField(
                          controller: openingStockController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
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
                        Text(
                            AppLocale.getText('lowStockAlert', widget.languageCode),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                        TextField(
                          controller: lowStockAlertController,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.notifications),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocale.getText('date', widget.languageCode),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
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
                                ? AppLocale.getText('selectDate', widget.languageCode)
                                : DateFormat('dd/MM/yyyy').format(selectedDate!),
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 250),

              Center(
                child: ElevatedButton(
                  onPressed: _saveItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 120),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                      AppLocale.getText('saveItem', widget.languageCode),
                      style: const TextStyle(fontSize: 16, color: Colors.white)
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