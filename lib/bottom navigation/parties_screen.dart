import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Add customer/ContactsScreen.dart';
import '../Add customer/add_cutomer.dart';
import '../I10n/app_locale.dart';
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
      home: const LanguageSelectionScreen(),
    );
  }
}

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

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('language') ?? 'en';
    });
  }

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
                      builder: (context) => PartiesScreen(
                        languageCode: value,
                        initialContact: {},
                      ),
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
                      builder: (context) => PartiesScreen(
                        languageCode: value,
                        initialContact: {},
                      ),
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

class PartiesScreen extends StatefulWidget {
  final String languageCode;
  final Map<String, String> initialContact;

  const PartiesScreen({
    super.key,
    required this.languageCode,
    required this.initialContact,
  });

  @override
  State<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends State<PartiesScreen> {
  int _currentIndex = 0;
  List<Contact> selectedContacts = [];
  List<Map<String, String>> manualContacts = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialContact.isNotEmpty) {
      manualContacts.add(widget.initialContact);
    }
  }

  late final List<Widget> _screens = [
    PartiesScreenContent(
      selectedContacts: selectedContacts,
      manualContacts: manualContacts,
      languageCode: widget.languageCode,
    ),
    BillsScreen(languageCode: widget.languageCode),
    ItemsScreen(
      itemName: '',
      salePrice: '',
      purchasePrice: '',
      languageCode: widget.languageCode,
    ),
    MoreScreen(languageCode: widget.languageCode),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _addCustomer(BuildContext context) async {
    Contact? contact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactsScreen(languageCode: '',)),
    );

    if (contact != null) {
      setState(() {
        selectedContacts.add(contact);
        _screens[0] = PartiesScreenContent(
          selectedContacts: selectedContacts,
          manualContacts: manualContacts,
          languageCode: widget.languageCode,
        );
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

class PartiesScreenContent extends StatelessWidget {
  final List<Contact> selectedContacts;
  final List<Map<String, String>> manualContacts;
  final String languageCode;

  const PartiesScreenContent({
    super.key,
    required this.selectedContacts,
    required this.manualContacts,
    required this.languageCode,
  });

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
          bottom: TabBar(
            indicatorColor: Colors.yellow,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: AppLocale.getText(AppLocale.customers, languageCode)),
              Tab(text: AppLocale.getText(AppLocale.suppliers, languageCode)),
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
                itemCount: selectedContacts.length + manualContacts.length,
                itemBuilder: (context, index) {
                  if (index < selectedContacts.length) {
                    Contact contact = selectedContacts[index];
                    return _buildCustomerTile(
                      context,
                      contact.displayName,
                      contact.phones.isNotEmpty
                          ? contact.phones.first.number
                          : AppLocale.getText(AppLocale.phoneNumber, languageCode),
                      '',
                      "₹ ${index * 10}",
                      index % 2 == 0 ? Colors.red : Colors.green,
                    );
                  } else {
                    final manualContact = manualContacts[index - selectedContacts.length];
                    return _buildCustomerTile(
                      context,
                      manualContact['name'] ?? '',
                      manualContact['phone'] ?? '',
                      manualContact['address'] ?? '',
                      "₹ ${index * 10}",
                      index % 2 == 0 ? Colors.red : Colors.green,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPartyScreen(
                  contact: selectedContacts.isNotEmpty ? selectedContacts.last : null, languageCode: 'mr',
                ),
              ),
            );

            if (result != null) {
              print('New contact added: ${result['name']}, ${result['phone']}, ${result['address']}');
            }
          },
          icon: const Icon(Icons.person_add),
          label: Text(AppLocale.getText(AppLocale.addCustomer, languageCode)),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildCustomerTile(
      BuildContext context, String name, String phone, String address, String amount, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(phone),
          if (address.isNotEmpty) Text(address, style: TextStyle(fontSize: 12)),
        ],
      ),
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
              address: address, // Pass the address here
              timeAgo: AppLocale.getText(AppLocale.recentTransactions, languageCode),
              amountColor: color,
            ),
          ),
        );
      },
    );
  }
  }
