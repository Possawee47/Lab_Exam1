import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [
    Expense(
      id: 'e1',
      name: 'ค่าอาหาร',
      amount: 300,
      category: 'อาหาร',
      date: DateTime.now(),
    ),
    Expense(
      id: 'e2',
      name: 'ค่าของใช้',
      amount: 500,
      category: 'ช้อปปิ้ง',
      date: DateTime.now(),
    ),
    Expense(
      id: 'e3',
      name: 'ค่ารถ',
      amount: 400,
      category: 'เดินทาง',
      date: DateTime.now(),
    ),
  ];

  int get total =>
      _expenses.fold(0, (sum, item) => sum + item.amount);

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push<Expense>(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddExpenseScreen(),
                ),
              );

              if (result != null) {
                _addExpense(result);
              }
            },
          ),
        ],
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = _expenses.removeAt(oldIndex);
            _expenses.insert(newIndex, item);
          });
        },
        children: _expenses.map((expense) {
          return Dismissible(
            key: ValueKey(expense.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              setState(() {
                _expenses.remove(expense);
              });
            },
            child: ListTile(
              tileColor: Colors.green.shade100,
              leading: const Icon(Icons.drag_handle),
              title: Text('${expense.name} - ${expense.amount}'),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.all(16),
        color: Colors.grey.shade300,
        child: Text(
          'Total: $total',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListTile(
          leading: const Icon(Icons.bar_chart),
          title: const Text('Statistics'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StatisticsScreen(expenses: _expenses),
              ),
            );
          },
        ),
      ),
    );
  }
}
