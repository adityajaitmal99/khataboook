import 'package:image_picker/image_picker.dart';

class TransactionDetails {
  final double amount;
  final String details;
  final DateTime date;
  final XFile? attachedBill;
  final bool isGave;
  final bool isGot;

  TransactionDetails({
    required this.amount,
    required this.details,
    required this.date,
    this.attachedBill,
    required this.isGave,
    required this.isGot,
  });
}