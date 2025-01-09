import 'package:flutter/material.dart';
import 'package:khataboook/pdf_page.dart'; // Import the Generate Bill screen
import '../I10n/app_locale.dart'; // Import your AppLocale class

class BillsScreen extends StatelessWidget {
  final String languageCode; // The language code (e.g., 'en' for English, 'mr' for Marathi)

  BillsScreen({required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(AppLocale.getText(AppLocale.title, languageCode)), // Localized app title
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}), // Settings icon
        ],
      ),
      body: Column(
        children: [
          _buildTopStatsSection(),
          const SizedBox(height: 10),
          _buildTabs(),
          const SizedBox(height: 10),
          _buildSearchAndFilter(),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Text(
                AppLocale.getText(AppLocale.noCustomers, languageCode), // Localized "No bills available"
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildFloatingButton(context),
    );
  }

  Widget _buildTopStatsSection() {
    return Container(
     // padding: const EdgeInsets.symmetric(vertical: 16.0),
      //color: Colors.blue.shade50,
     /* child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('₹0', AppLocale.getText(AppLocale.monthlySales, languageCode), Colors.green),
          _buildStatCard('₹0', AppLocale.getText(AppLocale.monthlyPurchases, languageCode), Colors.red),
          _buildStatCard('₹0', AppLocale.getText(AppLocale.todayIn, languageCode), Colors.blue),
          _buildStatCard('₹0', AppLocale.getText(AppLocale.todayOut, languageCode), Colors.orange),
        ],
      ),*/
    );
  }

  Widget _buildStatCard(String amount, String label, Color color) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTab(AppLocale.getText(AppLocale.sale, languageCode), isSelected: true),
          _buildTab(AppLocale.getText(AppLocale.purchase, languageCode)),
          _buildTab(AppLocale.getText(AppLocale.expense, languageCode)),
        ],
      ),
    );
  }

  Widget _buildTab(String title, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        // Add onTap functionality if needed
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: AppLocale.getText(AppLocale.searchForTransactions, languageCode), // Localized search hint
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.blue),
            onPressed: () {}, // Filter action
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PdfPage()),
        );
      },
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        AppLocale.getText(AppLocale.addBill, languageCode), // Localized "Add Bill"
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
    );
  }
}
