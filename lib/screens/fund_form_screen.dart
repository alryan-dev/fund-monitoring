import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/models/fund.dart';
import 'package:fund_monitoring/models/user_model.dart';
import 'package:fund_monitoring/utils.dart';

class FundFormScreen extends StatelessWidget {
  const FundFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Fund')),
      body: FundForm(),
    );
  }
}

class FundForm extends StatefulWidget {
  const FundForm({Key? key}) : super(key: key);

  @override
  _FundFormState createState() => _FundFormState();
}

class _FundFormState extends State<FundForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _dateFromCtrl = TextEditingController();
  final _dateToCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();
  final _datesFocusNode = FocusNode();
  final _fund = Fund();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              _amountField(),
              SizedBox(height: 15),
              _dateRangeField(),
              SizedBox(height: 15),
              _remarksField(),
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
          _fund.amount = amount;
        }

        return error;
      },
    );
  }

  Widget _dateRangeField() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextFormField(
            focusNode: _datesFocusNode,
            controller: _dateFromCtrl,
            decoration: InputDecoration(
              icon: Icon(Icons.date_range_outlined, size: 30),
              border: OutlineInputBorder(),
              labelText: 'Date From',
              isDense: true,
              helperText: '*Required',
              helperStyle: TextStyle(color: Colors.grey[600]),
            ),
            onTap: _showDatePickerDialog,
            validator: (value) =>
                (value!.isEmpty) ? 'Please select date' : null,
            readOnly: true,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 4,
          child: TextFormField(
            focusNode: _datesFocusNode,
            controller: _dateToCtrl,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Date To',
              isDense: true,
              helperText: '*Required',
              helperStyle: TextStyle(color: Colors.grey[600]),
            ),
            onTap: _showDatePickerDialog,
            validator: (value) =>
                (value!.isEmpty) ? 'Please select date' : null,
            readOnly: true,
          ),
        )
      ],
    );
  }

  void _showDatePickerDialog() async {
    FocusScope.of(context).requestFocus(_datesFocusNode);
    final date = DateTime.now();
    DateTimeRange? dateTimeRange;

    if (_fund.dateFrom != null && _fund.dateTo != null) {
      dateTimeRange = await showDateRangePicker(
        initialDateRange: DateTimeRange(
          start: _fund.dateFrom ?? date,
          end: _fund.dateTo ?? date,
        ),
        context: context,
        firstDate: DateTime(date.year, date.month - 1),
        lastDate: DateTime(date.year, date.month + 2, 0),
      );
    } else {
      dateTimeRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(date.year, date.month - 1),
        lastDate: DateTime(date.year, date.month + 2, 0),
      );
    }

    if (dateTimeRange != null) {
      _fund.dateFrom = dateTimeRange.start;
      _dateFromCtrl.text = Utils.dateTimeToString(dateTimeRange.start);
      _fund.dateTo = dateTimeRange.end;
      _dateToCtrl.text = Utils.dateTimeToString(dateTimeRange.end);
    }
  }

  Widget _remarksField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      minLines: 2,
      controller: _remarksCtrl,
      decoration: InputDecoration(
        icon: Icon(Icons.article_outlined, size: 30),
        border: OutlineInputBorder(),
        labelText: 'Remarks',
        isDense: true,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget saveBtn() {
    return Container(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) _saveFund();
        },
        child: Text('Save'.toUpperCase()),
      ),
    );
  }

  void _saveFund() async {
    FocusScope.of(context).unfocus();
    Utils.showSnackBar(context, "Saving...", duration: Duration(days: 365));

    _fund.remarks = _remarksCtrl.text;
    _fund.createdOn = DateTime.now();
    _fund.createdBy = UserModel(
      uid: FirebaseAuth.instance.currentUser?.uid ?? "",
      displayName: FirebaseAuth.instance.currentUser?.displayName ?? "",
      email: FirebaseAuth.instance.currentUser?.email ?? "",
    );

    try {
      await FirebaseFirestore.instance.collection('funds').add(_fund.toMap());
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/funds',
        (Route<dynamic> route) => false,
      );
      Utils.showSnackBar(context, "Fund Created!");
    } catch (e) {
      print("Error: $e");
    }
  }
}
