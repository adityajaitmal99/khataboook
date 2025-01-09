import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import for Google Sign-In
import 'I10n/app_locale.dart'; // Localization
import 'bottom navigation/parties_screen.dart';
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
          await _auth.signInWithCredential(credential);
          _showSnackbar(locale['otpAutoVerified'] ?? 'OTP auto-verified successfully!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationPage(
                languageCode: widget.languageCode,
                phoneNumber: phoneNumber,
                verificationId: '',
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
  /// Handles Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initiate the Google Sign-In process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Obtain the auth details from the Google Sign-In
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential using the token
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      await _auth.signInWithCredential(credential);

      // Navigate to the Parties Screen after successful Google Sign-In
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PartiesScreen(languageCode: widget.languageCode, initialContact: {},)),
      );

      _showSnackbar(locale['googleSignInSuccess'] ?? 'Google Sign-In Successful', isSuccess: true);
    } catch (e) {
      _showSnackbar(locale['googleSignInError'] ?? 'Google Sign-In failed. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Displays a snackbar with the given message
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
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          locale['appTitle'] ?? "SoftGrid Billing-App",  // App title can be localized
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
                    children: [
                      Image.asset('assets/indflag.jpg', width: 24, height: 24), // Flag Image
                      const SizedBox(width: 5),
                      const Text('+91', style: TextStyle(fontSize: 16)),
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
                : Column(
              children: [
                SizedBox(
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
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Image.asset('assets/google.png', width: 24, height: 24), // Google logo image
                    label: Text(
                      locale['signInWithGoogle'] ?? 'Sign in with Google',
                      style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
