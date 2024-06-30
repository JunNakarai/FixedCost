import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fixed_cost.dart';
import '../providers/fixed_cost_provider.dart';

class EditFixedCostScreen extends StatefulWidget {
  final FixedCost fixedCost;

  EditFixedCostScreen({required this.fixedCost});

  @override
  _EditFixedCostScreenState createState() => _EditFixedCostScreenState();
}

class _EditFixedCostScreenState extends State<EditFixedCostScreen> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fixedCost.name);
    _amountController =
        TextEditingController(text: widget.fixedCost.amount.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('固定費を編集'),
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
                  final newFixedCost = FixedCost(name: name, amount: amount);
                  Provider.of<FixedCostProvider>(context, listen: false)
                      .updateFixedCost(widget.fixedCost, newFixedCost);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}