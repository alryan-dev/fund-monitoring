import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fund_monitoring/models/expense_type.dart';
import 'package:fund_monitoring/models/fund.dart';
import 'package:fund_monitoring/models/user_model.dart';

class Expense {
  String uid = "";
  double amount = 0;
  ExpenseType? type;
  String description = "";
  DateTime? date;
  UserModel? createdBy;
  DateTime? createdOn;
  Fund? fund;

  Expense();

  Expense.fromFirestore(QueryDocumentSnapshot queryDocumentSnapshot) {
    Map expense = queryDocumentSnapshot.data() as Map<String, dynamic>;
    this.uid = queryDocumentSnapshot.id;
    this.amount = expense['amount'];
    this.type = ExpenseType.fromMap(expense["type"]);
    this.description = expense['description'];
    this.date = DateTime.fromMillisecondsSinceEpoch(expense['date']);
    this.createdBy = UserModel.fromMap(expense["createdBy"]);
    this.createdOn = DateTime.fromMillisecondsSinceEpoch(expense['createdOn']);
    this.fund = Fund.fromMap(expense["fund"]);
  }
}
