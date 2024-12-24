import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:permission_handler/permission_handler.dart';
import '../I10n/app_locale.dart'; // Assuming this handles the localization
import '../Add customer/ContactsScreen.dart'; // Import the ContactsScreen
import '../transaction_screens/TransactionDetailScreen.dart';
import 'bills_screen.dart';
import 'items_screen.dart';
import 'more_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PartiesScreen(languageCode: 'en'), // Default to English
    );
  }
}

class PartiesScreen extends StatefulWidget {
  final String languageCode;

  const PartiesScreen({super.key, required this.languageCode});

  @override
  State<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends State<PartiesScreen> {
  int _currentIndex = 0;

  // Store selected contacts here
  List<Contact> selectedContacts = [];

  final List<Widget> _screens = [
    PartiesScreenContent([]), // Pass empty list initially for selected contacts
    BillsScreen(),
    ItemsScreen(itemName: '', salePrice: '', purchasePrice: ''),
    MoreScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update current index for navigation
      if (index == 0) {
        // Update the Parties screen with selected contacts when navigating back
        _screens[0] = PartiesScreenContent(selectedContacts);
      }
    });
  }

  Future<void> _addCustomer(BuildContext context) async {
    Contact? contact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactsScreen()),
    );

    if (contact != null) {
      setState(() {
        selectedContacts.add(contact); // Add selected contact to list
        // Update the Parties screen with the new contact
        _screens[0] = PartiesScreenContent(selectedContacts);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the current screen based on index
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCustomer(context),
        icon: const Icon(Icons.person_add),
        label: Text(AppLocale.getText(AppLocale.addCustomer, widget.languageCode)),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.groups),
            label: AppLocale.getText(AppLocale.parties, widget.languageCode), // Localized text for "Parties"
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt),
            label: AppLocale.getText(AppLocale.bills, widget.languageCode), // Localized text for "Bills"
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: AppLocale.getText(AppLocale.items, widget.languageCode), // Localized text for "Items"
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            label: AppLocale.getText(AppLocale.more, widget.languageCode), // Localized text for "More"
          ),
        ],
      ),
    );
  }
}

class PartiesScreenContent extends StatelessWidget {

  final List<Contact> selectedContacts;

  // Accept selected contacts as a parameter
  const PartiesScreenContent(this.selectedContacts, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    AppLocale.getText(AppLocale.customers, 'en'),
                    // Assuming default language is English for demo
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.phone, color: Colors.white),
                      onPressed: () {}),
                  IconButton(icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {}),
                ],
              ),
              bottom: const TabBar(
                indicatorColor: Colors.yellow,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(text: 'CUSTOMERS'),
                  Tab(text: 'SUPPLIERS'),
                ],
              ),
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAmountCard(
                          "You Will Give", "₹ 5.83", Colors.lightGreenAccent),
                      _buildAmountCard("You Will Get", "₹ 26", Colors.red),
                      _buildAmountCard(
                          "QR Collections", "₹ 0", Colors.blue.shade200),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Search Customers",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(icon: const Icon(
                          Icons.filter_list, color: Colors.blue),
                          onPressed: () {}),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.book, color: Colors.blue),
                        label: const Text("Cashbook"),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: ListView.builder(
                      itemCount: selectedContacts.length,
                      // Displaying previously selected contacts
                      itemBuilder: (context, index) {
                        Contact contact = selectedContacts[index];
                        return _buildCustomerTile(context, contact.displayName,
                            contact.phones.isNotEmpty ? contact.phones.first
                                .number : "No phone number",
                            "₹ ${index * 10}", // Placeholder for amount
                            index % 2 == 0 ? Colors.red : Colors
                                .green); // Alternate colors for demo
                      },
                    )
                )
              ],
            )
        )
    );
  }

  Widget _buildAmountCard(String title, String amount, Color color) {
    return Column(
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
          const SizedBox(height: 4),
          Text(amount, style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          GestureDetector(onTap: () {}, child:
          Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration:
              BoxDecoration(color: Colors.white, borderRadius:
              BorderRadius.circular(20)),
              child:
              Text("Parties")),
          )
        ]
    );
  }

  Widget _buildCustomerTile(BuildContext context, String name, String phone,
      String amount, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(name),
      subtitle: Text(phone),
      trailing: Text(
          amount,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TransactionDetailScreen(
                  languageCode: 'en',
                  // Pass the language code as needed
                  name: name,
                  // Pass the customer name
                  number: phone,
                  // Pass the customer's phone number
                  timeAgo: 'Just Now',
                  // Use appropriate data here
                  amount: amount,
                  // Pass the amount
                  amountColor: color, // Pass the color for the amount
                ),
          ),
        );
      },
    );
  }
}