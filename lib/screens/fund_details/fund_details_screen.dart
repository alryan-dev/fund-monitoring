import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/app_states/selected_fund.dart';
import 'package:fund_monitoring/models/expense.dart';
import 'package:fund_monitoring/screens/fund_details/fund_details_appbar.dart';
import 'package:fund_monitoring/screens/fund_details/fund_details_tab.dart';
import 'package:fund_monitoring/screens/fund_details/fund_expenses_tab.dart';
import 'package:provider/provider.dart';

class FundDetailsScreen extends StatelessWidget {
  late final SelectedFund _selectedFund;

  @override
  Widget build(BuildContext context) {
    _selectedFund = Provider.of<SelectedFund>(context, listen: false);
    _loadFundExpenses();

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: FundDetailsAppBar(),
        body: TabBarView(
          children: <Widget>[
            FundExpensesTab(),
            FundDetailsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/expense-form'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _loadFundExpenses() {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance
        .collection('expenses')
        .where('fund.uid', isEqualTo: _selectedFund.fund?.uid)
        .orderBy('createdOn', descending: true)
        .snapshots();

    stream.listen((event) {
      List expenses = <Expense>[];

      for (QueryDocumentSnapshot value in event.docs) {
        Expense expense = Expense.fromFirestore(value);
        expenses.add(expense);
      }

      _selectedFund.expenseList = expenses;
    });
  }
}
