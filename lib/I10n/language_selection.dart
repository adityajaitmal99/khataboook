import 'package:flutter/material.dart';
import '../utils/welcome_page.dart';
 // Import the next screen for navigation

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage>
    with SingleTickerProviderStateMixin {
  String? _selectedLanguage; // Store selected language
  late AnimationController _animationController; // Animation Controller

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.8,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Handle Language Selection
  void _selectLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
    _animationController.forward(from: 0.8); // Trigger bounce animation
  }

  /// Navigate to the next screen with selected language
  void _navigateToNextPage() {
    if (_selectedLanguage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(languageCode: _selectedLanguage!),
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
        centerTitle: true,
        title: const Text(
          'Select Your Language',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Language Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLanguageOption(
                languageName: 'English',
                languageCode: 'en',
                isSelected: _selectedLanguage == 'en',
              ),
              _buildLanguageOption(
                languageName: 'मराठी',
                languageCode: 'mr',
                isSelected: _selectedLanguage == 'mr',
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Continue Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedLanguage == null ? null : _navigateToNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedLanguage != null
                      ? Colors.blueAccent
                      : Colors.grey, // Change button color when enabled
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'START USING KHATABOOK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Language Option with Bounce Animation
  Widget _buildLanguageOption({
    required String languageName,
    required String languageCode,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _selectLanguage(languageCode),
      child: ScaleTransition(
        scale: isSelected ? _animationController : const AlwaysStoppedAnimation(1.0),
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor:
                isSelected ? Colors.white : Colors.blueAccent,
                radius: 25,
                child: Text(
                  languageName[0], // Show first letter as icon
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blueAccent : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                languageName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
