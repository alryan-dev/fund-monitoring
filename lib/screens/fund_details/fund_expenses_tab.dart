import 'package:flutter/material.dart';
import 'package:fund_monitoring/app_states/selected_fund.dart';
import 'package:fund_monitoring/utils.dart';
import 'package:provider/provider.dart';

class FundExpensesTab extends StatefulWidget {
  const FundExpensesTab({Key? key}) : super(key: key);

  @override
  _FundExpensesTabState createState() => _FundExpensesTabState();
}

class _FundExpensesTabState extends State<FundExpensesTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedFund>(
      builder: (context, selectedFund, _) {
        return ListView.separated(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          itemCount: selectedFund.expenseList.length,
          itemBuilder: (context, idx) => ListTile(
            title:
                Text(Utils.formatAmount(selectedFund.expenseList[idx].amount)),
            subtitle: Text(selectedFund.expenseList[idx].type?.name ?? ''),
            onTap: () => Navigator.pushNamed(
              context,
              '/expense-details',
              arguments: selectedFund.expenseList[idx],
            ),
          ),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 0, thickness: 1),
        );
      },
    );
  }
}
