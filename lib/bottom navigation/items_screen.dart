import 'dart:io'; // For using Image.file
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
 // Import the image_picker package
import 'package:khataboook/bottom%20navigation/AddItemScreen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key, required String itemName, required String salePrice, required String purchasePrice});

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Map<String, dynamic>> items = [];
  final ImagePicker _picker = ImagePicker();  // ImagePicker instance

  // Function to add item to the list
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
        'stock': 0, // Initialize stock to 0
      });
    });
  }

  // Function to increase stock
  void _increaseStock(int index) {
    setState(() {
      items[index]['stock']++;
    });
  }

  // Function to decrease stock
  void _decreaseStock(int index) {
    setState(() {
      if (items[index]['stock'] > 0) {
        items[index]['stock']--;
      }
    });
  }

  // Function to capture or pick an image
  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);  // You can change this to ImageSource.gallery to pick from gallery
    if (pickedFile != null) {
      setState(() {
        items[index]['photo'] = pickedFile.path;  // Save the image path to the photo field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Vishal Jangle',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {}, // Settings functionality
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Stats Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.blue.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('₹0', 'Total Stock Value'),
                _buildStatCard('0', 'Low Stock Items'),
                GestureDetector(
                  onTap: () {
                    // Navigate to Reports
                  },
                  child: Text(
                    'VIEW REPORTS',
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
          // Search & Sort Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Items',
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
                  onPressed: () {}, // Sorting functionality
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Item List Section
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
      // Floating Action Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
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
                'stock': 0,  // Initialize stock to 0 for new items
              });
            });
          }
        },
        label: const Text("ADD PRODUCT", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add_box, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
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
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // Reduced padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligning items to the top
          children: [
            // Image on the left (Circle Avatar)
            GestureDetector(
              onTap: () => _pickImage(index), // Allow tapping to change image
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                radius: 30, // Reduced size
                child: photo.isNotEmpty
                    ? Image.file(File(photo), fit: BoxFit.cover) // Display the image if it's available
                    : const Icon(Icons.inventory, color: Colors.blue), // Default icon if no photo
              ),
            ),
            const SizedBox(width: 12), // Reduced space between image and text

            // Item details and stock information
            Expanded(
                child:  Column(
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
                        text: "Sale Price: ",
                        style: TextStyle(fontWeight: FontWeight.bold,),
                        children: [
                          TextSpan(
                            text: "₹$salePrice",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Purchase Price: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: "₹$purchasePrice",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: "Opening Stock: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: "$openingStock",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Low Stock Alert: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: "$lowStockAlert",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: "$selectedDate",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Stock: $stock",
                      style: TextStyle(
                        color: stock == 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
            ),

            // In and Out buttons positioned to the top-right
            Column(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green.shade700),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjust padding
                  ),
                  onPressed: () => _increaseStock(index),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Prevent Row from taking full width
                    children: [
                      Icon(Icons.add, color: Colors.green.shade700, size: 14),
                      const SizedBox(width: 4), // Add spacing between icon and text
                      Text("In", style: TextStyle(color: Colors.green.shade700)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.shade700,),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjust padding
                  ),
                  onPressed: () => _decreaseStock(index),
                  child: Row(
                    //mainAxisSize: MainAxisSize.min, // Prevent Row from taking full width
                    children: [
                      Icon(Icons.remove, color: Colors.red.shade700 , size: 14,),
                      const SizedBox(width: 0), // Add spacing between icon and text
                      Text("Out", style: TextStyle(color: Colors.red.shade700)),
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
