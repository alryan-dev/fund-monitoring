import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/models/expense_type.dart';
import 'package:fund_monitoring/screens/expense_types/expense_types_appbar.dart';

class ExpenseTypeScreen extends StatelessWidget {
  const ExpenseTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExpenseTypesAppBar(),
      body: ExpenseTypesList(),
    );
  }
}

class ExpenseTypesList extends StatefulWidget {
  const ExpenseTypesList({Key? key}) : super(key: key);

  @override
  _ExpenseTypesListState createState() => _ExpenseTypesListState();
}

class _ExpenseTypesListState extends State<ExpenseTypesList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('expenseTypes')
          .orderBy('createdOn', descending: true)
          .snapshots(),
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
            ExpenseType expenseType =
                ExpenseType.fromFirestore(snapshot.data!.docs[idx]);

            return ListTile(title: Text(expenseType.name));
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 0, thickness: 1),
        );
      },
    );
  }
}
