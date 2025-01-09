import 'package:flutter/material.dart';
import '../I10n/app_locale.dart';
import '../model/TransactionDetails.dart';
import 'package:intl/intl.dart';
import 'You Got screen.dart';
import 'You gave scren.dart';

class TransactionDetailScreen extends StatefulWidget {
  final String name;
  final String number;
  final String timeAgo;
  final Color amountColor;
  final String languageCode;
  final String? address;

  const TransactionDetailScreen({
    Key? key,
    required this.name,
    required this.number,
    required this.timeAgo,
    required this.amountColor,
    required this.languageCode,
    this.address,
  }) : super(key: key);

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  List<TransactionDetails> transactions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          AppLocale.getText('transactionDetails', widget.languageCode),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.number,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey
                    ),
                  ),
                  if (widget.address != null && widget.address!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.address!,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    AppLocale.getText('youWillGet', widget.languageCode),
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              AppLocale.getText('Transactions:-', widget.languageCode),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final color = transaction.isGave ? Colors.red.shade700 : Colors.green.shade700;
                  final amountPrefix = transaction.isGave ? '- ₹' : '+ ₹';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$amountPrefix${transaction.amount}',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.details,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd/MM/yyyy').format(transaction.date),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: transaction.attachedBill != null
                          ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.attachment,
                          color: Colors.blue,
                        ),
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: -2,
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () async {
                  final result = await Navigator.push<TransactionDetails>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionScreen(
                        name: widget.name,
                        isGave: true,
                        languageCode: widget.languageCode,
                      ),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      transactions.add(result);
                    });
                  }
                },
                child: Text(
                  AppLocale.getText('youGave', widget.languageCode),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () async {
                  final result = await Navigator.push<TransactionDetails>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionScreenn(
                        name: widget.name,
                        isGave: false,
                        languageCode: widget.languageCode,
                      ),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      transactions.add(result);
                    });
                  }
                },
                child: Text(
                  AppLocale.getText('youGot', widget.languageCode),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}