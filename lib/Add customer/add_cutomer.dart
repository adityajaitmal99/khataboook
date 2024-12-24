import 'package:flutter/material.dart';

void main() {
  runApp(AddPartyApp());
}

class AddPartyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddPartyScreen(),
    );
  }
}

class AddPartyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add Party'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Party name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            'https://imgs.search.brave.com/g7b4DndEO0vcg955Gc--OxTaDUOGUmmB9XFXRPH7EF4/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9jZG4u/YnJpdGFubmljYS5j/b20vOTcvMTU5Ny0w/NTAtMDA4RjMwRkEv/RmxhZy1JbmRpYS5q/cGc', // Placeholder flag icon URL
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 8),
                          Text('+91'),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('Who are they?'),
                Row(
                  children: [
                    Radio(
                      value: 'Customer',
                      groupValue: 'Customer', // Set selected radio button
                      onChanged: (value) {
                        // Handle radio change
                      },
                    ),
                    Text('Customer'),
                    SizedBox(width: 16),
                    Radio(
                      value: 'Supplier',
                      groupValue: 'Customer', // Set selected radio button
                      onChanged: (value) {
                        // Handle radio change
                      },
                    ),
                    Text('Supplier'),
                  ],
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // Handle GSTIN & Address addition
                  },
                  child: Text(
                    '+ ADD GSTIN & ADDRESS (OPTIONAL)',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -3), // Shadow only at the top
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ElevatedButton(
              onPressed: () {
                // Handle Add Customer action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'ADD  CUSTOMER',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
