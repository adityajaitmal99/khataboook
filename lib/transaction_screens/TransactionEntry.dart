import 'package:flutter/material.dart';

class TransactionEntry extends StatelessWidget {
  final String dateTime;
  final String balance;
  final String? youGave;
  final String? youGot;

  const TransactionEntry({
    Key? key,
    required this.dateTime,
    required this.balance,
    this.youGave,
    this.youGot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateTime,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                'Bal. $balance',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          if (youGave != null)
            Text(
              youGave!,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          if (youGot != null)
            Text(
              youGot!,
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
        ],
      ),
    );
  }
}
