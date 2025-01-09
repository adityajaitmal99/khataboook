import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'I10n/app_locale.dart'; // Import for translations
import 'package:khataboook/bottom%20navigation/parties_screen.dart'; // Import PartiesScreen

class OTPVerificationPage extends StatefulWidget {
  final String languageCode;
  final String phoneNumber;

  const OTPVerificationPage({
    super.key,
    required this.languageCode,
    required this.phoneNumber, required String verificationId,
  });

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  late Map<String, String> locale;
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String? _verificationId; // Holds the verification ID
  bool _isVerifying = false; // Shows loading state

  @override
  void initState() {
    super.initState();
    locale = AppLocale.getLocale(widget.languageCode);
    _sendOTP(); // Send OTP when the page loads
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

  String get _otp {
    return _otpControllers.map((controller) => controller.text).join();
  }

  /// Sends OTP to the given phone number
  Future<void> _sendOTP() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically verifies the OTP and logs in the user
          await FirebaseAuth.instance.signInWithCredential(credential);
          _onVerificationSuccess();
        },
        verificationFailed: (FirebaseAuthException e) {
          _showSnackbar(e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          _showSnackbar("OTP sent successfully");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      _showSnackbar("Error sending OTP: $e");
    }
  }

  /// Verifies the entered OTP
  Future<void> _verifyOTP() async {
    if (_otp.length != 6 || _verificationId == null) {
      _showSnackbar(locale['otpVerificationFailed'] ?? 'Invalid OTP. Please try again.');
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _onVerificationSuccess();
    } catch (e) {
      _showSnackbar(locale['otpVerificationFailed'] ?? 'Invalid OTP. Please try again.');
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  void _onVerificationSuccess() {
    _showSnackbar(locale['otpVerificationSuccess'] ?? 'OTP Verified Successfully!', isSuccess: true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PartiesScreen(languageCode: widget.languageCode, initialContact: {},),
      ),
    );
  }

  void _showSnackbar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
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
          locale['otpPageTitle'] ?? 'OTP Verification',
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
            const Icon(
              Icons.lock_outline_rounded,
              size: 100,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            Text(
              locale['otpSent'] ?? 'An OTP has been sent to your phone.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
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
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            _isVerifying
                ? const CircularProgressIndicator()
                : SizedBox(
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
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _sendOTP,
              child: Text(
                locale['resendOtp'] ?? 'Resend OTP',
                style: const TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
