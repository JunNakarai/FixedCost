import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fixed_cost.dart';
import '../providers/fixed_cost_provider.dart';

class AddFixedCostScreen extends StatefulWidget {
  const AddFixedCostScreen({super.key});
  @override
  _AddFixedCostScreenState createState() => _AddFixedCostScreenState();
}

class _AddFixedCostScreenState extends State<AddFixedCostScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('固定費を追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '固定費の名称'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: '金額'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final amount = int.tryParse(_amountController.text) ?? 0;

                if (name.isNotEmpty && amount > 0) {
                  final fixedCost = FixedCost(name: name, amount: amount);
                  Provider.of<FixedCostProvider>(context, listen: false)
                      .addFixedCost(fixedCost);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}
