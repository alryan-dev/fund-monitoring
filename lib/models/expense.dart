import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Map<String, dynamic> toMap() {
    Map<String, dynamic> expense = {
      "amount": this.amount,
      "type": this.type!.toMap(),
      "description": this.description,
      "date": this.date!.millisecondsSinceEpoch,
      "fund": this.fund?.toMap(),
    };

    if (this.uid.isNotEmpty) expense["uid"] = this.uid;
    if (this.createdOn == null)
      expense["createdOn"] = DateTime.now().toUtc().millisecondsSinceEpoch;

    if (this.createdBy == null) {
      expense["createdBy"] = {
        "uid": FirebaseAuth.instance.currentUser?.uid,
        "displayName": FirebaseAuth.instance.currentUser?.displayName,
        "email": FirebaseAuth.instance.currentUser?.email,
      };
    } else {
      expense["createdBy"] = {
        'uid': this.createdBy?.uid,
        'displayName': this.createdBy?.displayName,
        'email': this.createdBy?.email,
      };
    }

    return expense;
  }
}
