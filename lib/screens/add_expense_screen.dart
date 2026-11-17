import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/categories_provider.dart';
import 'package:expense_tracker/providers/currency_provider.dart';
import 'package:expense_tracker/utils/category_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key, this.expense});

  final Expense? expense;

  @override
  ConsumerState<AddExpenseScreen> createState() {
    return _AddExpenseScreenState();
  }
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  int? _selectedCategoryId;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _titleController = TextEditingController(text: expense?.title);
    _amountController = TextEditingController(
      text: expense == null
          ? null
          : (expense.amountCents / 100).toStringAsFixed(2),
    );
    _selectedCategoryId = expense?.categoryId;
    _selectedDate = expense?.date ?? DateTime.now();
  }

  double? _parseAmount(String? text) {
    return double.tryParse((text ?? '').replaceAll(',', '.'));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
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
        id: widget.expense?.id,
        title: _titleController.text.trim(),
        amountCents: (amount * 100).round(),
        date: _selectedDate,
        categoryId: _selectedCategoryId!,
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
    final l10n = AppLocalizations.of(context)!;
    final symbol = ref.watch(currencySymbolProvider);
    final categories = ref.watch(categoriesProvider).value ?? [];
    final items = categories
        .where((c) => !c.isDeleted || c.id == _selectedCategoryId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense == null ? l10n.addExpense : l10n.editExpense,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                maxLength: 50,
                decoration: InputDecoration(labelText: l10n.title),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.enterTitle;
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: l10n.amount,
                  prefixText: '$symbol ',
                ),
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final amount = _parseAmount(value);
                  if (amount == null || amount <= 0) {
                    return l10n.enterValidAmount;
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
                    child: DropdownButtonFormField<int>(
                      initialValue: _selectedCategoryId,
                      hint: Text(l10n.category),
                      validator: (value) =>
                          value == null ? l10n.selectCategory : null,
                      items: items
                          .map(
                            (category) => DropdownMenuItem<int>(
                              value: category.id,
                              child: Row(
                                children: [
                                  Icon(category.icon, color: category.color),
                                  const SizedBox(width: 4),
                                  Text(categoryName(category, l10n)),
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
                          _selectedCategoryId = value;
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
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _saveExpense,
                    child: Text(l10n.save),
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
