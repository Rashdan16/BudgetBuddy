// lib/models/transaction.dart

/// A simple data class representing one transaction.
class Transaction {
  /// The unique ID of the transaction (from your database).
  final int id;

  /// The amount spent in this transaction.
  final double amount;

  /// (Optional) When this transaction was created.
  /// If your backend is not yet sending this field, you can
  /// remove it for now or mark it nullable.
  final DateTime? createdAt;

  Transaction({required this.id, required this.amount, this.createdAt});

  /// Factory builder: makes a Transaction from a JSON map.
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      // If your endpoint returns "created_at": "2025-06-29T20:13:35Z"
      // uncomment the next line; otherwise leave createdAt null.
      createdAt: json.containsKey('created_at')
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
