import 'package:expense_tracker/models/budget.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class BudgetFormScreen extends StatefulWidget {
  const BudgetFormScreen({super.key, required this.categories, this.budget});

  final List<Category> categories;
  final Budget? budget;

  @override
  State<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends State<BudgetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  int? _categoryId;

  @override
  void initState() {
    super.initState();
    final budget = widget.budget;
    _categoryId = budget?.categoryId;
    _amountController = TextEditingController(
      text: budget == null
          ? null
          : (budget.limitCents / 100).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountController.text.replaceAll(',', '.'));
    Navigator.of(context).pop(
      Budget(
        id: widget.budget?.id,
        categoryId: _categoryId!,
        limitCents: (amount * 100).round(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budget == null ? 'New Budget' : 'Edit Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                initialValue: _categoryId,
                hint: const Text('Category'),
                validator: (value) =>
                    value == null ? 'Select a category' : null,
                items: widget.categories
                    .map(
                      (category) => DropdownMenuItem<int>(
                        value: category.id!,
                        child: Row(
                          children: [
                            Icon(category.icon, color: category.color),
                            const SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: widget.budget == null
                    ? (value) => setState(() => _categoryId = value)
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Monthly limit'),
                validator: (value) {
                  final amount = double.tryParse(
                    (value ?? '').replaceAll(',', '.'),
                  );
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
