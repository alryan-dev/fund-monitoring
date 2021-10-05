import 'package:flutter/material.dart';
import 'package:fund_monitoring/models/expense.dart';
import 'package:fund_monitoring/screens/expense_form/expense_form.dart';
import 'package:fund_monitoring/screens/expense_form/expense_form_appbar.dart';

class ExpenseFormScreen extends StatelessWidget {
  const ExpenseFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Expense? expense = ModalRoute.of(context)!.settings.arguments as Expense?;

    return Scaffold(
      appBar: ExpenseFormAppBar(expense),
      body: ExpenseForm(expense),
    );
  }
}
