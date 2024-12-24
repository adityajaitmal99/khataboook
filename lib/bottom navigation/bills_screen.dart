import 'package:flutter/material.dart';
import 'package:khataboook/pdf_page.dart'; // Import the Generate Bill screen

class BillsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Business Name'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}), // Settings icon
        ],
      ),
      body: Column(
        children: [
          // Top stats section
          _buildTopStatsSection(),
          const SizedBox(height: 10),
          // Tabs section (Sale, Purchase, Expense)
          _buildTabs(),
          const SizedBox(height: 10),
          // Search and filter section
          _buildSearchAndFilter(),
          const SizedBox(height: 10),
          // No bills message
          Expanded(
            child: Center(
              child: Text(
                "No bills available",
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
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      color: Colors.blue.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('₹0', 'Monthly Sales', Colors.green),
          _buildStatCard('₹0', 'Monthly Purchases', Colors.red),
          _buildStatCard('₹0', "Today's IN", Colors.blue),
          _buildStatCard('₹0', "Today's OUT", Colors.orange),
        ],
      ),
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
          _buildTab('Sale', isSelected: true),
          _buildTab('Purchase'),
          _buildTab('Expense'),
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
                hintText: 'Search for transactions',
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
      label: const Text(
        "Add Bill",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
    );
  }
}
