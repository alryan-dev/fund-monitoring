import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpenseTypesAppBar extends StatefulWidget with PreferredSizeWidget {
  const ExpenseTypesAppBar({Key? key}) : super(key: key);

  @override
  _ExpenseTypesAppBarState createState() => _ExpenseTypesAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ExpenseTypesAppBarState extends State<ExpenseTypesAppBar> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Expense Types'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _showAddDialog,
        ),
      ],
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Expense Type'),
          content: _nameField(),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) _saveExpenseType();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _nameField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _nameCtrl,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Name',
          isDense: true,
        ),
        validator: (value) => (value!.isEmpty) ? 'Please enter name' : null,
      ),
    );
  }

  void _saveExpenseType() async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> expenseType = {
      'name': _nameCtrl.text,
      'createdOn': DateTime.now().toUtc().millisecondsSinceEpoch,
    };

    try {
      FirebaseFirestore.instance.collection('expenseTypes').add(expenseType);
      _formKey.currentState?.reset();
      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameCtrl.dispose();
  }
}
