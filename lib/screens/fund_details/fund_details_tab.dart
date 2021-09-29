import 'package:flutter/material.dart';
import 'package:fund_monitoring/app_states/selected_fund.dart';
import 'package:fund_monitoring/models/user_model.dart';
import 'package:fund_monitoring/utils.dart';
import 'package:provider/provider.dart';

class FundDetailsTab extends StatelessWidget {
  final TextStyle labelStyles = TextStyle(color: Colors.grey[600]);
  final TextStyle valueStyles = TextStyle(fontSize: 17);

  @override
  Widget build(BuildContext context) {
    SelectedFund selectedFund =
        Provider.of<SelectedFund>(context, listen: false);
    Divider divider = Divider(height: 30, thickness: 1);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fundAmountField(selectedFund.fund?.amount),
            divider,
            dateRangeField(
              selectedFund.fund?.dateFrom,
              selectedFund.fund?.dateTo,
            ),
            divider,
            createdByField(selectedFund.fund?.createdBy),
            divider,
            createdOnField(selectedFund.fund?.createdOn),
            divider,
            remarksField(selectedFund.fund?.remarks),
          ],
        ),
      ),
    );
  }

  Widget fundAmountField(double? amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fund Amount:', style: labelStyles),
        SizedBox(height: 1),
        Text(Utils.formatAmount(amount), style: valueStyles),
      ],
    );
  }

  Widget dateRangeField(DateTime? dateFrom, DateTime? dateTo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date Range:', style: labelStyles),
        SizedBox(height: 1),
        Text(
          "${Utils.dateTimeToString(dateFrom)} - ${Utils.dateTimeToString(dateTo)}",
          style: valueStyles,
        ),
      ],
    );
  }

  Widget createdByField(UserModel? userModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Created By:', style: labelStyles),
        SizedBox(height: 1),
        Text(userModel!.displayName, style: valueStyles),
      ],
    );
  }

  Widget createdOnField(DateTime? dateTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Created On:', style: labelStyles),
        SizedBox(height: 1),
        Text('${Utils.dateTimeToString(dateTime)}', style: valueStyles),
      ],
    );
  }

  Widget remarksField(String? remarks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Remarks:', style: labelStyles),
        SizedBox(height: 1),
        Text(remarks!, style: valueStyles),
      ],
    );
  }
}
