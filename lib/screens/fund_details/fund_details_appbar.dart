import 'package:flutter/material.dart';
import 'package:fund_monitoring/app_states/selected_fund.dart';
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
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {},
        ),
      ],
      flexibleSpace: Container(
        padding: EdgeInsets.only(
          left: 56,
          top: AppBar().preferredSize.height + 20
        ),
        child: Consumer<SelectedFund>(
          builder: (context, selectedFund, _) => Column(
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
                Utils.formatAmount(selectedFund.remainingAmount),
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
                    '${(selectedFund.fund?.closed ?? false) ? "Closed" : "Active"}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: (selectedFund.fund?.closed ?? false)
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
}
