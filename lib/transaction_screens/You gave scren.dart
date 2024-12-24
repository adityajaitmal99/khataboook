import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isCalculatorVisible = false;
  XFile? _image;  // To hold the picked image

  final ImagePicker _picker = ImagePicker();

  // Function to handle date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to handle save action
  void _saveTransaction() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an amount!")),
      );
      return;
    }
    // Add your save logic here
    print("Transaction Saved with Amount: ${_amountController.text}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaction Saved!")),
    );
  }

  // Function to pick an image using the camera
  Future<void> _pickImage() async {
    // Check for camera permission
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isGranted) {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission denied")),
      );
    }
  }

  // Custom calculator button widget
  Widget _calcButton(String text, {Color color = Colors.white, Function()? onPressed}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 5, // Shadow effect for buttons
          shadowColor: Colors.black.withOpacity(0.3), // Light shadow color
        ),
        child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.black)),
      ),
    );
  }

  // Function to handle calculator input
  void _onCalculatorButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _amountController.clear();
      } else if (buttonText == '⌫') {
        if (_amountController.text.isNotEmpty) {
          _amountController.text = _amountController.text.substring(0, _amountController.text.length - 1);
        }
      } else if (buttonText == "=") {
        try {
          // Evaluating the expression
          _amountController.text = _evaluateExpression(_amountController.text);
        } catch (e) {
          _amountController.text = 'Error';
        }
      } else {
        _amountController.text += buttonText;
      }
    });
  }

  // A simple expression evaluator for basic arithmetic operations
  String _evaluateExpression(String expression) {
    try {
      // Basic replacement of operators for a simple eval
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      final result = _calculateExpression(expression);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  // Function to calculate the result of an arithmetic expression
  double _calculateExpression(String expression) {
    final parts = expression.split(RegExp(r'(\+|\-|\×|\÷)'));
    double result = double.tryParse(parts[0]) ?? 0;
    for (int i = 1; i < parts.length; i += 2) {
      double nextValue = double.tryParse(parts[i + 1]) ?? 0;
      switch (parts[i]) {
        case '+':
          result += nextValue;
          break;
        case '-':
          result -= nextValue;
          break;
        case '×':
          result *= nextValue;
          break;
        case '÷':
          if (nextValue != 0) {
            result /= nextValue;
          } else {
            return double.nan; // Avoid division by zero
          }
          break;
      }
    }
    return result;
  }

  // Handle input field focus
  void _onAmountFieldFocusChange(bool hasFocus) {
    setState(() {
      _isCalculatorVisible = hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("You gave ₹ 5 to Aditya Jaitmal"),
        backgroundColor: Colors.red,
      ),
      body: GestureDetector(
        onTap: () {
          // Hide the calculator when tapping outside of the input fields
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount input (now using calculator only, keyboard disabled)
              Focus(
                onFocusChange: _onAmountFieldFocusChange,
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.none,  // Disable the standard keyboard
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.currency_rupee, color: Colors.red),
                    hintText: "Enter Amount",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Details input
              TextField(
                controller: _detailsController,
                decoration: InputDecoration(
                  hintText: "Enter details (Items, bill no., quantity, etc.)",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Date picker and attachment row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.red),
                          const SizedBox(width: 10),
                          Text(
                            "${_selectedDate.day} ${_selectedDate.month} ${_selectedDate.year}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt, color: Colors.red),
                    label: const Text("Attach bills"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Show the image preview if an image is picked
              if (_image != null)
                Image.file(
                  File(_image!.path),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),

              SizedBox(height: 20),// Save button
              ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text("SAVE"),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),

      // Positioned calculator fixed to the bottom
      bottomSheet: _isCalculatorVisible
          ? Padding(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 3),
        child: Container(
          color: Colors.white, // Background color for calculator container
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 1.5,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 6.0,
            children: [
              _calcButton("C", onPressed: () => _onCalculatorButtonPressed("C")),
              _calcButton("M+", onPressed: () {}),
              _calcButton("M-", onPressed: () {}),
              _calcButton("⌫", onPressed: () => _onCalculatorButtonPressed("⌫")),
              ...["7", "8", "9", "÷", "4", "5", "6", "×", "1", "2", "3", "-"]
                  .map((e) => _calcButton(e, onPressed: () => _onCalculatorButtonPressed(e))),
              _calcButton("0", onPressed: () => _onCalculatorButtonPressed("0")),
              _calcButton(".", onPressed: () {
                if (!_amountController.text.contains(".")) {
                  _onCalculatorButtonPressed(".");
                }
              }),
              _calcButton("=", onPressed: () => _onCalculatorButtonPressed("=")),
              _calcButton("+", onPressed: () => _onCalculatorButtonPressed("+")),
            ],
          ),
        ),
      )
          : null,
    );
  }
}
