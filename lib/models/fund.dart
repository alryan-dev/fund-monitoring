import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fund_monitoring/models/user_model.dart';
import 'package:intl/intl.dart';

class Fund {
  String uid = "";
  double amount = 0;
  DateTime? dateFrom;
  DateTime? dateTo;
  String remarks = "";
  UserModel? createdBy;
  DateTime? createdOn;
  bool closed = false;

  Fund();

  Fund.fromFirestore(QueryDocumentSnapshot queryDocumentSnapshot) {
    Map fund = queryDocumentSnapshot.data() as Map<String, dynamic>;
    this.uid = queryDocumentSnapshot.id;
    this.amount = fund['amount'];
    this.dateFrom = DateFormat.yMMMd().parse(fund['dateFrom']);
    this.dateTo = DateFormat.yMMMd().parse(fund['dateTo']);
    this.remarks = fund['remarks'];
    this.createdOn = DateFormat.yMMMd().parse(fund['createdOn']);
    this.closed = fund['closed'];
    this.createdBy = UserModel.fromMap(fund["createdBy"]);
  }
}