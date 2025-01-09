import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../bottom navigation/parties_screen.dart';
import '../I10n/app_locale.dart'; // Import localization utility

class AddPartyScreen extends StatefulWidget {
  final Contact? contact;
  final String languageCode; // Accept language code

  const AddPartyScreen({Key? key, this.contact, required this.languageCode}) : super(key: key);

  @override
  _AddPartyScreenState createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  // Error messages
  String? nameError;
  String? phoneError;
  String? addressError;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact?.displayName ?? '');
    phoneController = TextEditingController(
        text: widget.contact?.phones.isNotEmpty ?? false
            ? widget.contact?.phones.first.number
            : '');
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Validation function
  bool _validateForm() {
    bool isValid = true;

    // Validate name
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = AppLocale.getText(AppLocale.nameRequired, widget.languageCode);
      });
      isValid = false;
    } else {
      setState(() {
        nameError = null;
      });
    }

    // Validate phone number (only digits and exactly 10 digits)
    if (phoneController.text.isEmpty) {
      setState(() {
        phoneError = AppLocale.getText(AppLocale.phoneRequired, widget.languageCode);
      });
      isValid = false;
    } else if (phoneController.text.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phoneController.text)) {
      setState(() {
        phoneError = AppLocale.getText(AppLocale.invalidPhone, widget.languageCode);
      });
      isValid = false;
    } else {
      setState(() {
        phoneError = null;
      });
    }

    // Validate address (ensure it is not empty)
    if (addressController.text.isEmpty) {
      setState(() {
        addressError = AppLocale.getText(AppLocale.addressRequired, widget.languageCode);
      });
      isValid = false;
    } else {
      setState(() {
        addressError = null;
      });
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocale.getText(AppLocale.addParty, widget.languageCode)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name input field
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: AppLocale.getText(AppLocale.partyName, widget.languageCode),
                    border: const OutlineInputBorder(),
                    errorText: nameError,
                  ),
                ),
                const SizedBox(height: 16),

                // Phone number input field
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/indflag.jpg',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          Text('+91'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: AppLocale.getText(AppLocale.mobileNumber, widget.languageCode),
                          border: const OutlineInputBorder(),
                          errorText: phoneError,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Address input field
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: AppLocale.getText(AppLocale.address, widget.languageCode),
                    border: const OutlineInputBorder(),
                    errorText: addressError,
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ElevatedButton(
              onPressed: () {
                if (_validateForm()) {
                  final contactData = {
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'address': addressController.text,
                  };

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PartiesScreen(
                        languageCode: widget.languageCode,
                        initialContact: contactData,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                AppLocale.getText(AppLocale.addCustomer, widget.languageCode),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
