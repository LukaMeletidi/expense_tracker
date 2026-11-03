import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() {
    return _AddExpenseScreenState();
  }
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  DateTime _selectedDate = DateTime.now();

  double? _parseAmount(String? text) {
    return double.tryParse((text ?? '').replaceAll(',', '.'));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 6, now.month, now.day),
      lastDate: now,
    );
    if (!mounted || pickedDate == null) return;
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = _parseAmount(_amountController.text)!;
    Navigator.of(context).pop(
      Expense(
        title: _titleController.text.trim(),
        amountCents: (amount * 100).round(),
        date: _selectedDate,
        category: _selectedCategory,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                ),
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final amount = _parseAmount(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter the valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_month),
                  ),
                  Text(DateFormat('d MMM y').format(_selectedDate)),
                  const SizedBox(width: 40),
                  Expanded(
                    child: DropdownButtonFormField<ExpenseCategory>(
                      initialValue: _selectedCategory,
                      items: ExpenseCategory.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Row(
                                children: [
                                  Icon(category.icon),
                                  const SizedBox(width: 4),
                                  Text(category.label),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                  ElevatedButton(
                    onPressed: _saveExpense,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
