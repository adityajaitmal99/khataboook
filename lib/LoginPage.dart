import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'I10n/app_locale.dart'; // Localization
import 'otp_verification.dart'; // OTP Verification Page

class LoginPage extends StatefulWidget {
  final String languageCode; // Language code passed dynamically
  const LoginPage({super.key, required this.languageCode});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Map<String, String> locale; // To hold translations dynamically
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch the localization strings dynamically from AppLocale
    locale = AppLocale.getLocale(widget.languageCode);
  }

  /// Sends OTP to the entered phone number
  Future<void> _sendOTP() async {
    final String phoneNumber = '+91${_phoneController.text.trim()}';

    if (_phoneController.text.isEmpty || _phoneController.text.length != 10) {
      _showSnackbar(locale['invalidPhoneNumber'] ?? 'Enter a valid phone number');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // This callback is triggered for auto-verification.
          await _auth.signInWithCredential(credential);
          _showSnackbar(locale['otpAutoVerified'] ?? 'OTP auto-verified successfully!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationPage(
                languageCode: widget.languageCode,
                phoneNumber: phoneNumber, verificationId: '',
              ),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          _showSnackbar(e.message ?? 'Failed to send OTP');
        },
        codeSent: (String verificationId, int? resendToken) {
          _showSnackbar(locale['otpSent'] ?? 'OTP sent successfully!');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationPage(
                languageCode: widget.languageCode,
                phoneNumber: phoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _showSnackbar(locale['otpTimeout'] ?? 'OTP request timed out. Try again.');
        },
      );
    } catch (e) {
      _showSnackbar(locale['otpError'] ?? 'Error sending OTP. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Displays a snackbar with the given message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "KhataBook",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.flag, size: 18, color: Colors.orangeAccent),
                      SizedBox(width: 5),
                      Text('+91', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: locale['phoneNumber'] ?? 'Enter phone number',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  locale['getOtp'] ?? 'Get OTP',
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
