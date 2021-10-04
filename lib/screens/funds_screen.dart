import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/app_states/selected_fund.dart';
import 'package:fund_monitoring/models/fund.dart';
import 'package:fund_monitoring/utils.dart';
import 'package:provider/provider.dart';

class FundsScreen extends StatelessWidget {
  const FundsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        title: Text("Funds"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/fund-form'),
          ),
        ],
      ),
      body: FundsList(),
    );
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Fund Monitoring'),
          ),
          ListTile(
            title: const Text('Funds'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Text('Expense Types'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/expense-types');
            },
          ),
          ListTile(
            title: const Text('Log-out'),
            onTap: () {
              Navigator.pop(context);
              logout(context);
            },
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) async {
    Utils.showSnackBar(
      context,
      "Logging out...",
      duration: Duration(days: 365),
    );

    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(
          context, '/log-in', (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    } catch (e) {
      print('Error: $e');
    }
  }
}

class FundsList extends StatefulWidget {
  const FundsList({Key? key}) : super(key: key);

  @override
  _FundsListState createState() => _FundsListState();
}

class _FundsListState extends State<FundsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('funds').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading"));
        }

        return ListView.separated(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, idx) {
            Fund fund = Fund.fromFirestore(snapshot.data!.docs[idx]);
            String dateRange =
                "${Utils.dateTimeToString(fund.dateFrom)} - ${Utils.dateTimeToString(fund.dateTo)}";

            return ListTile(
              isThreeLine: true,
              title: Text(dateRange),
              subtitle: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: '${Utils.formatAmount(fund.amount)}\n',
                      style: TextStyle(fontSize: 15),
                    ),
                    TextSpan(
                      text: '${(fund.closed) ? "Closed" : "Active"}',
                      style: TextStyle(
                        color: (fund.closed) ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Container(
                height: double.infinity,
                child: Icon(Icons.chevron_right_outlined, size: 30),
              ),
              onTap: () {
                SelectedFund selectedFund =
                    Provider.of<SelectedFund>(context, listen: false);
                selectedFund.fund = fund;
                Navigator.pushNamed(context, '/fund-details');
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 0, thickness: 1),
        );
      },
    );
  }
}
