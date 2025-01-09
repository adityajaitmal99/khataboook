import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../I10n/app_locale.dart'; // Assuming AppLocale is in this file

class MoreScreen extends StatefulWidget {
  final String languageCode;

  // Accept languageCode as a parameter
  const MoreScreen({super.key, required this.languageCode});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _isAppInfoVisible = false;
  User? _currentUser;

  // Use widget.languageCode to get the passed language code
  String get languageCode => widget.languageCode;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  // Method to handle Logout
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      setState(() {
        _currentUser = null; // Reset the user details after logout
      });
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      _showSnackbar(AppLocale.getText(AppLocale.logout, languageCode));
    }
  }

  // Display a snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocale.getText(AppLocale.more, languageCode)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Profile Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  radius: 40,
                  child: const Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentUser != null
                            ? _currentUser!.displayName ?? AppLocale.getText(AppLocale.profile, languageCode)
                            : AppLocale.getText(AppLocale.more, languageCode),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentUser != null
                            ? _currentUser!.email ?? 'abc@gmail.com'
                            : AppLocale.getText(AppLocale.more, languageCode),
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          if (_currentUser != null) {
                            // Navigate to Edit Profile Screen
                          } else {
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          _currentUser != null
                              ? AppLocale.getText(AppLocale.updateProfile, languageCode)
                              : AppLocale.getText(AppLocale.logout, languageCode),
                          style: const TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Features Section
          _buildFeatureCard(
            title: AppLocale.getText(AppLocale.settings, languageCode),
            icon: Icons.settings,
            onTap: () {
              // Navigate to Business Settings
            },
          ),
          _buildFeatureCard(
            title: AppLocale.getText(AppLocale.language, languageCode),
            icon: Icons.language,
            onTap: () {
              // Handle language change
            },
          ),
          _buildFeatureCard(
            title: AppLocale.getText(AppLocale.notifications, languageCode),
            icon: Icons.notifications,
            onTap: () {
              // Navigate to Notifications screen
            },
          ),
          const SizedBox(height: 10),

          // App Info Section
          GestureDetector(
            onTap: () {
              setState(() {
                _isAppInfoVisible = !_isAppInfoVisible;
              });
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocale.getText(AppLocale.more, languageCode),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    _isAppInfoVisible
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          if (_isAppInfoVisible)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(AppLocale.getText(AppLocale.settings, languageCode), "1.0.0"),
                  const Divider(),
                  _buildInfoRow(AppLocale.getText(AppLocale.logout, languageCode), AppLocale.getText(AppLocale.logout, languageCode)),
                  const Divider(),
                  _buildInfoRow(AppLocale.getText(AppLocale.language, languageCode), AppLocale.getText(AppLocale.language, languageCode)),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Footer Section
          const SizedBox(height: 150),

          // Footer Section



          // Logout Button Section
          if (_currentUser != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppLocale.getText(AppLocale.logout, languageCode),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

            ),
          const SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://media.licdn.com/dms/image/v2/D4D0BAQH8VdbyuY3QhA/company-logo_200_200/company-logo_200_200/0/1704270419417?e=2147483647&v=beta&t=QREDXpthLMxwOr3K-E9yNU-4jbZPAHGiPHMSGmv3pGQ",
                  height: 50,
                  width: 50,
                ),
                const SizedBox(width: 8),
                Text(
                  "Powered by SoftGrid Info App",
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],

      ),
    );
  }

  // Helper method to build feature cards
  Widget _buildFeatureCard({required String title, required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // Helper method to build information rows
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
      ],
    );
  }
}
