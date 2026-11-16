import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/default_categories.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class ExpensesDatabase {
  static Database? _database;

  static Future<void> _createCategories(Database db) async {
    await db.execute(
      'CREATE TABLE categories( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, icon_key TEXT, color INTEGER, is_deleted INTEGER DEFAULT 0)',
    );
    for (final category in defaultCategories) {
      await db.insert('categories', category.toMap());
    }
  }

  static Future<Database> _getDatabase() async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, 'expense.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE expenses( id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount_cents INTEGER, date TEXT, category TEXT, category_id INTEGER)',
        );
        await _createCategories(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createCategories(db);
          await db.execute(
            'ALTER TABLE expenses ADD COLUMN category_id INTEGER',
          );
          await db.execute(
            'UPDATE expenses SET category_id = (SELECT id FROM categories WHERE icon_key = expenses.category)',
          );
        }
      },
    );
    return _database!;
  }

  static Future<Expense> insertExpense(Expense expense) async {
    final db = await _getDatabase();
    final id = await db.insert('expenses', expense.toMap());
    return Expense(
      id: id,
      title: expense.title,
      amountCents: expense.amountCents,
      date: expense.date,
      category: expense.category,
    );
  }

  static Future<List<Expense>> getExpenses() async {
    final db = await _getDatabase();
    final rows = await db.query('expenses', orderBy: 'date DESC');
    return rows.map((row) => Expense.fromMap(row)).toList();
  }

  static Future<void> deleteExpense(int id) async {
    final db = await _getDatabase();
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateExpense(Expense expense) async {
    final db = await _getDatabase();
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }
}
