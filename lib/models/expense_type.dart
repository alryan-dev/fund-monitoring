import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseType {
  String uid = "";
  String name = "";

  ExpenseType();

  ExpenseType.fromFirestore(QueryDocumentSnapshot queryDocumentSnapshot) {
    Map expenseType = queryDocumentSnapshot.data() as Map<String, dynamic>;
    this.uid = queryDocumentSnapshot.id;
    this.name = expenseType['name'];
  }

  ExpenseType.fromMap(Map expenseType) {
    this.uid = expenseType['uid'];
    this.name = expenseType['name'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> expenseType = {"name": this.name};
    if (this.uid.isNotEmpty) expenseType["uid"] = this.uid;
    return expenseType;
  }
}
