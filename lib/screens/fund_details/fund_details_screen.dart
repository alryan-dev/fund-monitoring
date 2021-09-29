import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/screens/fund_details/fund_details_appbar.dart';
import 'package:fund_monitoring/screens/fund_details/fund_details_tab.dart';

class FundDetailsScreen extends StatelessWidget {
  const FundDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: FundDetailsAppBar(),
        body: TabBarView(
          children: <Widget>[
            Center(child: Text("It's cloudy here")),
            FundDetailsTab(),
          ],
        ),
      ),
    );
  }
}
