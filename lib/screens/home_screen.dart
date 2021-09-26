import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/models/fund.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
}

class FundsList extends StatefulWidget {
  const FundsList({Key? key}) : super(key: key);

  @override
  _FundsListState createState() => _FundsListState();
}

class _FundsListState extends State<FundsList> {
  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0.00", "en_PH");

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
                "${DateFormat.yMMMd().format(fund.dateFrom as DateTime)} - "
                "${DateFormat.yMMMd().format(fund.dateFrom as DateTime)}";

            return ListTile(
              isThreeLine: true,
              title: Text(dateRange),
              subtitle: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: '₱ ${numberFormat.format(fund.amount)}\n',
                      style: TextStyle(fontSize: 15),
                    ),
                    TextSpan(
                      text: '${(fund.closed) ? "Closed" : "Active"}',
                      style: TextStyle(
                        color: (fund.closed) ? Colors.blue : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Container(
                height: double.infinity,
                child: Icon(Icons.chevron_right_outlined, size: 30),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 0, thickness: 1),
        );
      },
    );
  }
}
