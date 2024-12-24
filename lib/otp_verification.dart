import 'package:flutter/material.dart';
import 'I10n/app_locale.dart'; // Import for translations
import 'package:khataboook/bottom%20navigation/parties_screen.dart'; // Import PartiesScreen

class OTPVerificationPage extends StatefulWidget {
  final String languageCode;
  const OTPVerificationPage({super.key, required this.languageCode});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  late Map<String, String> locale;
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    locale = AppLocale.getLocale(widget.languageCode);
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  /// Combines OTP fields into a single string
  String get _otp {
    return _otpControllers.map((controller) => controller.text).join();
  }

  /// OTP Verification Logic
  void _verifyOTP() {
    if (_otp.length == 6) {
      // Simulate OTP Verification Success
      print("Entered OTP: $_otp");

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locale['otpVerificationSuccess'] ?? 'OTP Verified Successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to PartiesScreen after OTP verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PartiesScreen(languageCode: widget.languageCode)),
      );
    } else {
      // Show error for invalid OTP
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locale['otpVerificationFailed'] ?? 'Invalid OTP. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          locale['otpPageTitle'] ?? 'OTP Verification', // Title localization
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Lock Icon
            const Icon(
              Icons.lock_outline_rounded,
              size: 100,
              color: Colors.blueAccent,
            ),

            const SizedBox(height: 20),

            // Subtitle
            Text(
              locale['otpSent'] ?? 'An OTP has been sent to your phone.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 30),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 55,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 5) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index + 1]);
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context)
                            .requestFocus(_focusNodes[index - 1]);
                      }
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            // Verify OTP Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  locale['verifyOtp'] ?? 'Verify OTP',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Resend OTP
            TextButton(
              onPressed: () {
                // Logic for resending OTP
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("OTP resent successfully.....!"),
                    backgroundColor: Colors.orangeAccent,
                  ),
                );
              },
              child: Text(
                locale['resendOtp'] ?? 'Resend OTP',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
