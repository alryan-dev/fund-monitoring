import 'package:flutter/material.dart';
import 'package:fund_monitoring/models/expense.dart';
import 'package:fund_monitoring/utils.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Expense expense = ModalRoute.of(context)!.settings.arguments as Expense;

    return Scaffold(
      appBar: AppBar(title: Text('Expense Details')),
      body: ExpenseDetails(expense),
    );
  }
}

class ExpenseDetails extends StatelessWidget {
  final TextStyle labelStyles = TextStyle(color: Colors.grey[600]);
  final TextStyle valueStyles = TextStyle(fontSize: 17);
  final Expense expense;

  ExpenseDetails(this.expense, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Divider divider = Divider(height: 30, thickness: 1);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _expenseAmountField(),
            divider,
            _typeField(),
            divider,
            _descriptionField(),
            divider,
            _dateField(),
            divider,
            createdByField(),
            divider,
            createdOnField(),
          ],
        ),
      ),
    );
  }

  Widget _expenseAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amount:', style: labelStyles),
        SizedBox(height: 1),
        Text(Utils.formatAmount(expense.amount), style: valueStyles),
      ],
    );
  }

  Widget _typeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Type:', style: labelStyles),
        SizedBox(height: 1),
        Text(expense.type?.name ?? '', style: valueStyles),
      ],
    );
  }

  Widget _descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description:', style: labelStyles),
        SizedBox(height: 1),
        Text(expense.description, style: valueStyles),
      ],
    );
  }

  Widget _dateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date:', style: labelStyles),
        SizedBox(height: 1),
        Text(
          '${Utils.dateTimeToString(expense.date)}',
          style: valueStyles,
        ),
      ],
    );
  }

  Widget createdByField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Created By:', style: labelStyles),
        SizedBox(height: 1),
        Text(expense.createdBy?.displayName ?? '', style: valueStyles),
      ],
    );
  }

  Widget createdOnField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Created On:', style: labelStyles),
        SizedBox(height: 1),
        Text('${Utils.dateTimeToString(expense.createdOn)}',
            style: valueStyles),
      ],
    );
  }
}
