import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../I10n/app_locale.dart'; // Localization helper
import 'add_cutomer.dart'; // Screen to add a new customer

class ContactsScreen extends StatefulWidget {
  final String languageCode; // Language code for localization

  const ContactsScreen({super.key, required this.languageCode});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Contact> _contacts = [];
  final List<Contact> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(_filterContacts);
  }

  Future<void> _fetchContacts() async {
    setState(() {
      _loading = true;
    });

    // Request permission and fetch contacts
    bool permissionGranted = await FlutterContacts.requestPermission();
    if (permissionGranted) {
      List<Contact> contacts = await FlutterContacts.getContacts(
        withThumbnail: true,
        withProperties: true,
      );
      setState(() {
        _contacts.addAll(contacts);
        _filteredContacts.addAll(contacts);
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });

      // Notify the user if permission is denied
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocale.getText('permissionDenied', widget.languageCode)),
      ));
    }
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts
        ..clear()
        ..addAll(
          _contacts.where((contact) =>
              contact.displayName.toLowerCase().contains(query)),
        );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectContact(Contact contact) {
    Navigator.pop(context, contact);
  }

  void _navigateToAddPartyScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPartyScreen(languageCode: widget.languageCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.getText('selectContact', widget.languageCode)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocale.getText('searchContacts', widget.languageCode),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterContacts();
                  },
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredContacts.isEmpty
                ? Center(
              child: Text(AppLocale.getText(
                  'noContactsFound', widget.languageCode)),
            )
                : ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: contact.thumbnail != null
                        ? MemoryImage(contact.thumbnail!)
                        : null,
                    child: contact.thumbnail == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(contact.displayName),
                  subtitle: Text(contact.phones.isNotEmpty
                      ? contact.phones.first.number
                      : AppLocale.getText(
                      'noPhoneNumber', widget.languageCode)),
                  onTap: () => _selectContact(contact),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPartyScreen,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
