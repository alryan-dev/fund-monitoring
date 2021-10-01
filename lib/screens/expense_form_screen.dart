import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/app_states/selected_fund.dart';
import 'package:fund_monitoring/models/expense.dart';
import 'package:fund_monitoring/models/expense_type.dart';
import 'package:fund_monitoring/utils.dart';
import 'package:provider/provider.dart';

class ExpenseFormScreen extends StatelessWidget {
  const ExpenseFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: ExpenseForm(),
    );
  }
}

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({Key? key}) : super(key: key);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _expense = Expense();
  List _typesList = <ExpenseType>[];

  @override
  Widget build(BuildContext context) {
    _expense.date = DateTime.now();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              _amountField(),
              SizedBox(height: 15),
              _typeField(),
              SizedBox(height: 15),
              _descriptionField(),
              SizedBox(height: 15),
              _dateField(),
              SizedBox(height: 15),
              saveBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _amountField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _amountCtrl,
      inputFormatters: [
        CurrencyTextInputFormatter(
          decimalDigits: 2,
          symbol: '₱',
          locale: 'en_PH',
        ),
      ],
      decoration: InputDecoration(
        icon: Icon(Icons.payments_outlined, size: 30),
        border: OutlineInputBorder(),
        labelText: 'Amount',
        isDense: true,
        helperText: '*Required',
        helperStyle: TextStyle(color: Colors.grey[600]),
      ),
      validator: (String? value) {
        value = value?.replaceAll("₱", "").replaceAll(",", "");
        double amount = (value!.isNotEmpty) ? double.parse(value) : 0;
        String? error;

        if (amount <= 0) {
          error = 'Please enter amount';
        } else {
          _expense.amount = amount;
        }

        return error;
      },
    );
  }

  Widget _typeField() {
    _fetchTypes();

    return TextFormField(
      controller: _typeCtrl,
      decoration: InputDecoration(
        icon: Icon(Icons.category_outlined, size: 30),
        border: OutlineInputBorder(),
        labelText: 'Type',
        isDense: true,
        helperText: '*Required',
        helperStyle: TextStyle(color: Colors.grey[600]),
      ),
      onTap: _showSelectTypeDialog,
      validator: (value) => (value!.isEmpty) ? 'Please select type' : null,
      readOnly: true,
    );
  }

  void _fetchTypes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('expenseTypes')
        .orderBy('name')
        .get();

    querySnapshot.docs.forEach((element) {
      _typesList.add(ExpenseType.fromFirestore(element));
    });
  }

  void _showSelectTypeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Select Type'),
          children: [
            for (ExpenseType type in _typesList)
              RadioListTile(
                value: type,
                groupValue: _expense.type,
                title: Text(type.name),
                onChanged: (value) {
                  _expense.type = value as ExpenseType;
                  _typeCtrl.text = _expense.type?.name ?? '';
                  Navigator.pop(context);
                },
              )
          ],
        );
      },
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      minLines: 2,
      controller: _descriptionCtrl,
      decoration: InputDecoration(
        icon: Icon(Icons.article_outlined, size: 30),
        border: OutlineInputBorder(),
        labelText: 'Description',
        isDense: true,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _dateField() {
    _dateCtrl.text = Utils.dateTimeToString(DateTime.now());

    return TextFormField(
      controller: _dateCtrl,
      decoration: InputDecoration(
        icon: Icon(Icons.event, size: 30),
        border: OutlineInputBorder(),
        labelText: 'Date',
        isDense: true,
        helperText: '*Required',
        helperStyle: TextStyle(color: Colors.grey[600]),
      ),
      onTap: _showDatePickerDialog,
      validator: (value) => (value!.isEmpty) ? 'Please select date' : null,
      readOnly: true,
    );
  }

  void _showDatePickerDialog() async {
    final currentDate = DateTime.now();
    DateTime? selectedDate;

    if (_expense.date != null) {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: _expense.date ?? currentDate,
        currentDate: _expense.date,
        firstDate: DateTime(currentDate.year, currentDate.month - 1),
        lastDate: DateTime(currentDate.year, currentDate.month + 1, 0),
      );
    } else {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(currentDate.year, currentDate.month - 1),
        lastDate: DateTime(currentDate.year, currentDate.month + 1, 0),
      );
    }

    if (selectedDate != null) {
      _expense.date = selectedDate;
      _dateCtrl.text = Utils.dateTimeToString(selectedDate);
    }
  }

  Widget saveBtn() {
    return Container(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) _saveExpense();
        },
        child: Text('Save'.toUpperCase()),
      ),
    );
  }

  void _saveExpense() async {
    FocusScope.of(context).unfocus();
    Utils.showSnackBar(context, "Saving...", duration: Duration(days: 365));

    Map<String, dynamic> expense = {
      'amount': _expense.amount,
      'type': {
        'uid': _expense.type?.uid,
        'name': _expense.type?.name,
      },
      'description': _descriptionCtrl.text,
      'date': _expense.date?.toUtc().millisecondsSinceEpoch,
      'createdBy': {
        'uid': FirebaseAuth.instance.currentUser?.uid,
        'displayName': FirebaseAuth.instance.currentUser?.displayName,
        'email': FirebaseAuth.instance.currentUser?.email,
      },
      'createdOn': DateTime.now().toUtc().millisecondsSinceEpoch,
      'fund': Provider.of<SelectedFund>(context, listen: false).fund?.toMap()
    };

    try {
      await FirebaseFirestore.instance.collection('expenses').add(expense);
      Navigator.pop(context);
      Utils.showSnackBar(context, "Expense Added!");
    } catch (e) {
      print("Error: $e");
    }
  }
}
