import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/models/expense.dart';
import 'package:fund_monitoring/utils.dart';

class ExpenseFormAppBar extends StatefulWidget with PreferredSizeWidget {
  final Expense? expense;

  const ExpenseFormAppBar(this.expense, {Key? key}) : super(key: key);

  @override
  _ExpenseFormAppBarState createState() => _ExpenseFormAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ExpenseFormAppBarState extends State<ExpenseFormAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text((widget.expense == null) ? "Add Expense" : "Edit Expense"),
      actions: [
        if (widget.expense != null)
          IconButton(
            onPressed: _showDeleteDialog,
            icon: Icon(Icons.delete),
          )
      ],
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Expense?'),
          content: Text('Are your sure you want to delete this expense?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteExpense();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteExpense() async {
    Utils.showSnackBar(context, "Deleting...", duration: Duration(days: 365));

    try {
      FirebaseFirestore.instance
          .collection('expenses')
          .doc(widget.expense?.uid)
          .delete();
      Navigator.pop(context);
      Utils.showSnackBar(context, "Deleted!");
    } catch (e) {
      print("Error: $e");
    }
  }
}
