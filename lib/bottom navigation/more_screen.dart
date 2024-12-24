import 'package:flutter/material.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _isAppInfoVisible = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed the background color to white
      appBar: AppBar(
        title: const Text('More'),
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
                      const Text(
                        "Username ",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "abc@gmail.com",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          // Navigate to Edit Profile Screen
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(fontSize: 14, color: Colors.blue),
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
            title: "Business Settings",
            icon: Icons.settings,
            onTap: () {
              // Navigate to Business Settings
            },
          ),
          _buildFeatureCard(
            title: "Share App",
            icon: Icons.share,
            onTap: () {
              // Share app functionality
            },
          ),
          _buildFeatureCard(
            title: "Rate Us",
            icon: Icons.star,
            onTap: () {
              // Navigate to Rate Us screen
            },
          ),
          _buildFeatureCard(
            title: "Help & Support",
            icon: Icons.help,
            onTap: () {
              // Navigate to Help & Support screen
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
                  const Text(
                    "App Info",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  _buildInfoRow("Version", "1.0.0"),
                  const Divider(),
                  _buildInfoRow("Privacy Policy", "Read"),
                  const Divider(),
                  _buildInfoRow("Terms & Conditions", "Read"),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Footer Section
          const SizedBox(height: 250),

          // Footer Section
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
          const SizedBox(height: 20),

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
