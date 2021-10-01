import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/app_states/selected_fund.dart';
import 'package:fund_monitoring/models/fund.dart';
import 'package:fund_monitoring/utils.dart';
import 'package:provider/provider.dart';

class FundDetailsAppBar extends StatefulWidget with PreferredSizeWidget {
  const FundDetailsAppBar({Key? key}) : super(key: key);

  @override
  _FundDetailsAppBarState createState() => _FundDetailsAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(180);
}

class _FundDetailsAppBarState extends State<FundDetailsAppBar> {
  late SelectedFund _selectedFund;

  @override
  Widget build(BuildContext context) {
    _selectedFund = Provider.of(context);
    Fund? fund = _selectedFund.fund;

    print('_FundDetailsAppBarState');
    print(_selectedFund.fund?.closed);

    return AppBar(
      actions: [
        if (!(_selectedFund.fund?.closed ?? false)) IconButton(
          icon: Icon(Icons.check),
          onPressed: _showCloseConfirmationDialog,
        ),
      ],
      flexibleSpace: Container(
        padding:
            EdgeInsets.only(left: 56, top: AppBar().preferredSize.height + 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Remaining Amount',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              Utils.formatAmount(_selectedFund.remainingAmount),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Transform(
              transform: new Matrix4.identity()..scale(0.8),
              child: Chip(
                label: Text(
                  '${(_selectedFund.fund?.closed ?? false) ? "Closed" : "Active"}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (_selectedFund.fund?.closed ?? false)
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
      bottom: TabBar(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
          insets: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        tabs: <Widget>[
          Tab(text: 'Expenses'),
          Tab(text: 'Details'),
        ],
      ),
    );
  }

  void _showCloseConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to close this fund?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => _closeFund(),
            ),
          ],
        );
      },
    );
  }

  void _closeFund() async {
    Navigator.pop(context);
    _showLoadingDialog();

    try {
      await FirebaseFirestore.instance
          .collection('funds')
          .doc(_selectedFund.fund?.uid)
          .update({'closed': true});

      _selectedFund.fund?.closed = true;
      _selectedFund.fund = _selectedFund.fund;

      Navigator.pop(context);
      Utils.showSnackBar(context, "Fund Closed!");
    } catch (e) {
      print("Error: $e");
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            children: [CircularProgressIndicator(), Text('Closing...')],
          ),
        );
      },
    );
  }
}
