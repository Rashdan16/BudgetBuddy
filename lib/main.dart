import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/transaction.dart';
import 'pages/transactions_page.dart';
// ─── Imports ────────────────────────────────────────────────────────────────────


// ─── Model ─────────────────────────────────────────────────────────────────────



// ─── App Entry Point ────────────────────────────────────────────────────────────

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudgetBuddy 🚀',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

// ─── Home Page ─────────────────────────────────────────────────────────────────

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _amountCtrl = TextEditingController();
  // This list holds all the transactions fetched from the server
  // It starts empty and will be populated after fetching data
  List<Transaction> _transactions = [];
  // This controller handles the input for the transaction amount

  /// Computes the sum of all transaction amounts.
  double get _totalSpent =>
      _transactions.fold(0.0, (sum, tx) => sum + tx.amount);


  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    final uri = Uri.parse('http://10.0.2.2:5000/transactions');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _transactions =
              data.map((e) => Transaction.fromJson(e as Map<String, dynamic>)).toList();
        });
      } else {
        // Optionally show an error SnackBar
      }
    } catch (e) {
      // Optionally show network error SnackBar
    }
  }

  Future<void> _saveTransaction() async {
    final text = _amountCtrl.text.trim();
    final amt = double.tryParse(text);
    if (amt == null || amt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a positive number')),
      );
      return;
    }

    final uri = Uri.parse('http://10.0.2.2:5000/transactions');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amt}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction saved! ✅')),
        );
        _amountCtrl.clear();
        await _loadTransactions(); // refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BudgetBuddy 🚀')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input form
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount (£)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveTransaction,
              child: const Text('Save Transaction'),
            ),
            const SizedBox(height: 24),
            Text(
              'Total Spent: £${_totalSpent.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionsPage(transactions: _transactions),
                  ),
                );    
              },
              child: const Text('View All Transactions'),,
            ),
          ],
        ),
      ),
    );
  }
}
