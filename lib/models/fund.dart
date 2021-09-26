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
}