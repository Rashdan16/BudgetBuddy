// lib/pages/transactions_page.dart

import 'package:flutter/material.dart';
import '../models/transaction.dart';

/// A full-screen page that shows a scrollable list of past transactions.
class TransactionsPage extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsPage({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Transactions')),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions yet'))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, i) {
                final tx = transactions[i];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('£${tx.amount.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 12)),
                  ),
                  title: Text('Transaction #${tx.id}'),
                  subtitle: Text('Amount: £${tx.amount.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
}
