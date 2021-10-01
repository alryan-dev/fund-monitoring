import 'package:flutter/material.dart';
import 'package:fund_monitoring/models/expense.dart';
import 'package:fund_monitoring/models/fund.dart';

class SelectedFund with ChangeNotifier {
  Fund? _fund;
  double remainingAmount = 0;
  List _expenseList = <Expense>[];

  Fund? get fund => _fund;

  set fund(Fund? fund) {
    remainingAmount = fund?.amount ?? 0;
    _fund = fund;
  }

  List get expenseList => _expenseList;

  set expenseList(List expenseList) {
    _expenseList = expenseList;
    double totalExpenses = 0;

    _expenseList.forEach((element) {
      totalExpenses += element.amount;
    });

    remainingAmount = fund?.amount ?? 0;
    remainingAmount -= totalExpenses;
    notifyListeners();
  }
}