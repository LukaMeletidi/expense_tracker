import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expenses_provider.dart';
import 'package:expense_tracker/providers/period_provider.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/utils/filter_expenses.dart';
import 'package:expense_tracker/utils/group_by_date.dart';
import 'package:expense_tracker/widgets/day_header.dart';
import 'package:expense_tracker/widgets/dismissible_expense.dart';
import 'package:expense_tracker/widgets/period_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/widgets/category_breakdown.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildMainList() {
    final expensesAsync = ref.watch(periodExpensesProvider);
    return expensesAsync.when(
      error: (error, stack) => Center(child: Text('Error $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (expenses) {
        final items = flattenByDate(expenses);
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: items.length + 1,
          itemBuilder: (ctx, index) {
            if (index == 0) {
              return const Column(
                children: [PeriodSelector(), CategoryBreakdown()],
              );
            }
            final item = items[index - 1];
            if (item is DateTime) {
              return DayHeader(day: item);
            }
            final expense = item as Expense;
            return DismissibleExpense(
              key: ValueKey(expense.id),
              expense: expense,
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResults() {
    final allAsync = ref.watch(expensesProvider);
    return allAsync.when(
      error: (error, stack) => Center(child: Text('Error $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (all) {
        final results = filterByTitle(all, _query);
        if (results.isEmpty) {
          return const Center(child: Text('No expenses found'));
        }
        final items = flattenByDate(results);
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: items.length,
          itemBuilder: (ctx, index) {
            final item = items[index];
            if (item is DateTime) return DayHeader(day: item);
            final expense = item as Expense;
            return DismissibleExpense(
              key: ValueKey(expense.id),
              expense: expense,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search by name',
              leading: const Icon(Icons.search),
              trailing: [
                if (_query.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                    icon: const Icon(Icons.close),
                  ),
              ],
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: _query.trim().isEmpty
                ? _buildMainList()
                : _buildSearchResults(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push<Expense>(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          if (!context.mounted || newExpense == null) return;
          ref.read(expensesProvider.notifier).addExpense(newExpense);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
