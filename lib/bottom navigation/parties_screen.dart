import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart'; // For Flutter Contacts package
import 'package:permission_handler/permission_handler.dart'; // For permission handling
import 'package:shared_preferences/shared_preferences.dart'; // For shared preferences
import '../I10n/app_locale.dart'; // Localization handling
import '../Add customer/ContactsScreen.dart'; // Contact screen for adding customers
import '../transaction_screens/TransactionDetailScreen.dart'; // Transaction screen for details
import 'bills_screen.dart'; // Bills screen
import 'items_screen.dart'; // Items screen
import 'more_screen.dart'; // More screen

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
      home: const LanguageSelectionScreen(),
    );
  }
}

// Language selection screen where the user picks the language
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // Load the saved language from shared preferences
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('language') ?? 'en'; // Default to 'en' if no language is saved
    });
  }

  // Save the selected language to shared preferences
  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', languageCode);
    setState(() {
      selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('English'),
            leading: Radio<String>(
              value: 'en',
              groupValue: selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  _saveLanguage(value);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PartiesScreen(languageCode: value),
                    ),
                  );
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Marathi'),
            leading: Radio<String>(
              value: 'mr',
              groupValue: selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  _saveLanguage(value);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PartiesScreen(languageCode: value),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Parties screen, where customers are shown based on selected language
class PartiesScreen extends StatefulWidget {
  final String languageCode;

  const PartiesScreen({super.key, required this.languageCode});

  @override
  State<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends State<PartiesScreen> {
  int _currentIndex = 0;
  List<Contact> selectedContacts = [];

  final List<Widget> _screens = [
    PartiesScreenContent([], languageCode: 'en'), // Pass empty list initially for selected contacts
    BillsScreen(),
    ItemsScreen(itemName: '', salePrice: '', purchasePrice: ''),
    MoreScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        _screens[0] = PartiesScreenContent(selectedContacts, languageCode: widget.languageCode);
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
        selectedContacts.add(contact);
        _screens[0] = PartiesScreenContent(selectedContacts, languageCode: widget.languageCode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
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
            label: AppLocale.getText(AppLocale.parties, widget.languageCode),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt),
            label: AppLocale.getText(AppLocale.bills, widget.languageCode),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: AppLocale.getText(AppLocale.items, widget.languageCode),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            label: AppLocale.getText(AppLocale.more, widget.languageCode),
          ),
        ],
      ),
    );
  }
}

// This screen contains the list of parties (customers, suppliers)
class PartiesScreenContent extends StatelessWidget {
  final List<Contact> selectedContacts;
  final String languageCode;

  const PartiesScreenContent(this.selectedContacts, {super.key, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Row(
            children: [
              const Icon(Icons.menu_book, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                AppLocale.getText(AppLocale.customers, languageCode),
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: AppLocale.getText(AppLocale.searchCustomer, languageCode),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.blue),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.book, color: Colors.blue),
                    label: Text(AppLocale.getText(AppLocale.cashbook, languageCode)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectedContacts.length,
                itemBuilder: (context, index) {
                  Contact contact = selectedContacts[index];
                  return _buildCustomerTile(
                    context,
                    contact.displayName,
                    contact.phones.isNotEmpty ? contact.phones.first.number : AppLocale.getText(AppLocale.phoneNumber, languageCode),
                    "₹ ${index * 10}",
                    index % 2 == 0 ? Colors.red : Colors.green,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerTile(BuildContext context, String name, String phone, String amount, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(name),
      subtitle: Text(phone),
      trailing: Text(
        amount,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(
              languageCode: languageCode,
              name: name,
              number: phone,
              timeAgo: AppLocale.getText(AppLocale.recentTransactions, languageCode),
              amount: amount,
              amountColor: color,
            ),
          ),
        );
      },
    );
  }
}
