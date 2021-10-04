import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fund_monitoring/models/user_model.dart';

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
    this.dateFrom = DateTime.fromMillisecondsSinceEpoch(fund['dateFrom']);
    this.dateTo = DateTime.fromMillisecondsSinceEpoch(fund['dateTo']);
    this.remarks = fund['remarks'];
    this.createdOn = DateTime.fromMillisecondsSinceEpoch(fund['createdOn']);
    this.closed = fund['closed'];
    this.createdBy = UserModel.fromMap(fund["createdBy"]);
  }

  Fund.fromMap(Map fund) {
    this.uid = fund['uid'];
    this.amount = fund['amount'];
    this.dateFrom = DateTime.fromMillisecondsSinceEpoch(fund['dateFrom']);
    this.dateTo = DateTime.fromMillisecondsSinceEpoch(fund['dateTo']);
    this.remarks = fund['remarks'];
    this.createdOn = DateTime.fromMillisecondsSinceEpoch(fund['createdOn']);
    this.closed = fund['closed'];
    this.createdBy = UserModel.fromMap(fund["createdBy"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'amount': this.amount,
      'dateFrom': this.dateFrom?.toUtc().millisecondsSinceEpoch,
      'dateTo': this.dateTo?.toUtc().millisecondsSinceEpoch,
      'remarks': this.remarks,
      'createdBy': {
        'uid': this.createdBy?.uid,
        'displayName': this.createdBy?.displayName,
        'email': this.createdBy?.email,
      },
      'createdOn': this.createdOn?.toUtc().millisecondsSinceEpoch,
      'closed': this.closed
    };
  }
}
