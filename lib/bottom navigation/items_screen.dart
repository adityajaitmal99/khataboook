import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khataboook/bottom%20navigation/AddItemScreen.dart';
import '../I10n/app_locale.dart';

class ItemsScreen extends StatefulWidget {
  final String languageCode;

  const ItemsScreen({
    super.key,
    required this.languageCode,
    required String itemName,
    required String salePrice,
    required String purchasePrice,
  });

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Map<String, dynamic>> items = [];
  final ImagePicker _picker = ImagePicker();

  void _addItem(String itemName, String salePrice, String purchasePrice, String photo, String openingStock, String lowStockAlert, String selectedDate) {
    setState(() {
      items.add({
        'itemName': itemName,
        'photo': photo,
        'salePrice': salePrice,
        'purchasePrice': purchasePrice,
        'openingStock': openingStock,
        'lowStockAlert': lowStockAlert,
        'selectedDate': selectedDate,
        'stock': 0,
      });
    });
  }

  void _increaseStock(int index) {
    setState(() {
      items[index]['stock']++;
    });
  }

  void _decreaseStock(int index) {
    setState(() {
      if (items[index]['stock'] > 0) {
        items[index]['stock']--;
      }
    });
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        items[index]['photo'] = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocale.getText(AppLocale.stockManagement, widget.languageCode),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.blue.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    AppLocale.getText(AppLocale.viewReports, widget.languageCode),
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                      hintText: AppLocale.getText(AppLocale.searchItems, widget.languageCode),
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildItemCard(
                  items[index]['itemName'],
                  items[index]['salePrice'],
                  items[index]['purchasePrice'],
                  items[index]['stock'],
                  items[index]['photo'],
                  items[index]['openingStock'],
                  items[index]['lowStockAlert'],
                  items[index]['selectedDate'],
                  index,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen(languageCode: widget.languageCode)),
          );

          if (result != null) {
            setState(() {
              items.add({
                'itemName': result['itemName'],
                'photo': result['photo'],
                'salePrice': result['salePrice'],
                'purchasePrice': result['purchasePrice'],
                'openingStock': result['openingStock'],
                'lowStockAlert': result['lowStockAlert'],
                'selectedDate': result['selectedDate'],
                'stock': 0,
              });
            });
          }
        },
        label: Text(
            AppLocale.getText(AppLocale.addProduct, widget.languageCode),
            style: const TextStyle(color: Colors.white)
        ),
        icon: const Icon(Icons.add_box, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildItemCard(
      String itemName,
      String salePrice,
      String purchasePrice,
      int stock,
      String photo,
      String openingStock,
      String lowStockAlert,
      String selectedDate,
      int index,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _pickImage(index),
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                radius: 30,
                child: photo.isNotEmpty
                    ? Image.file(File(photo), fit: BoxFit.cover)
                    : const Icon(Icons.inventory, color: Colors.blue),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      text: AppLocale.getText(AppLocale.salePrice, widget.languageCode),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: " ₹$salePrice",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: AppLocale.getText(AppLocale.purchasePrice, widget.languageCode),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: " ₹$purchasePrice",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      text: AppLocale.getText(AppLocale.openingStock, widget.languageCode),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: " $openingStock",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: AppLocale.getText(AppLocale.lowStockAlert, widget.languageCode),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: " $lowStockAlert",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: AppLocale.getText(AppLocale.date, widget.languageCode),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: " $selectedDate",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${AppLocale.getText(AppLocale.stock, widget.languageCode)}: $stock",
                    style: TextStyle(
                      color: stock == 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green.shade700),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () => _increaseStock(index),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.green.shade700, size: 14),
                      const SizedBox(width: 4),
                      Text(
                          AppLocale.getText(AppLocale.inStockStatus, widget.languageCode),
                          style: TextStyle(color: Colors.green.shade700)
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.shade700),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  onPressed: () => _decreaseStock(index),
                  child: Row(
                    children: [
                      Icon(Icons.remove, color: Colors.red.shade700, size: 14),
                      const SizedBox(width: 0),
                      Text(
                          AppLocale.getText(AppLocale.outOfStockStatus, widget.languageCode),
                          style: TextStyle(color: Colors.red.shade700)
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}