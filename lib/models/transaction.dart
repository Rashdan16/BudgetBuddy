// lib/models/transactions.dart

/// A simple data class representing one transaction.
class Transaction {
  /// The unique ID of the transaction (from your database).
  final int id;

  /// The amount spent in this transaction.
  final double amount;

  /// Time when the transaction was created.
  final DateTime date;

  /// Constructor: both fields are required.
  Transaction({
    required this.id,
    required this.amount,
    required this.date,
  });

  /// Factory builder: makes a Transaction from a JSON map.
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      // JSON numbers can be int or double, so we normalize to double:
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['created_at'] as String),
    );
  }
}
