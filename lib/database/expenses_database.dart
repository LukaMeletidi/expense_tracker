import 'package:expense_tracker/models/expense.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ExpensesDatabase {
  static Database? _database;

  static Future<Database> _getDatabase() async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, 'expense.db'),
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE expenses( id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount_cents INTEGER, date TEXT, category TEXT)',
      ),
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
