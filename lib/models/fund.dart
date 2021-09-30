import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fund_monitoring/models/user_model.dart';
import 'package:fund_monitoring/utils.dart';

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
    this.dateFrom = Utils.stringToDateTime(fund['dateFrom']);
    this.dateTo = Utils.stringToDateTime(fund['dateTo']);
    this.remarks = fund['remarks'];
    this.createdOn = Utils.stringToDateTime(fund['createdOn']);
    this.closed = fund['closed'];
    this.createdBy = UserModel.fromMap(fund["createdBy"]);
  }

  Fund.fromMap(Map fund) {
    this.uid = fund['uid'];
    this.amount = fund['amount'];
    this.dateFrom = Utils.stringToDateTime(fund['dateFrom']);
    this.dateTo = Utils.stringToDateTime(fund['dateTo']);
    this.remarks = fund['remarks'];
    this.createdOn = Utils.stringToDateTime(fund['createdOn']);
    this.closed = fund['closed'];
    this.createdBy = UserModel.fromMap(fund["createdBy"]);
  }
}