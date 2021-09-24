import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/utils.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign-up")),
      body: SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              emailField(),
              SizedBox(height: 15),
              nameField(),
              SizedBox(height: 15),
              passwordField(),
              SizedBox(height: 15),
              confirmPasswordField(),
              SizedBox(height: 15),
              signUpBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailCtrl,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
        isDense: true,
      ),
      validator: (String? value) {
        String? error;

        if (value!.isEmpty) {
          error = 'Please enter your email';
        } else if (!value.contains("@")) {
          error = 'Invalid email';
        }

        return error;
      },
    );
  }

  Widget nameField() {
    return TextFormField(
      controller: _nameCtrl,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Name',
        isDense: true,
      ),
      validator: (value) => (value!.isEmpty) ? 'Please enter your name' : null,
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordCtrl,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      validator: (value) {
        String? error;

        if (value!.isEmpty) {
          error = 'Please enter your password';
        } else if (value != _confirmPasswordCtrl.text) {
          error = 'Passwords did not match';
        }

        return error;
      },
    );
  }

  Widget confirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordCtrl,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      validator: (value) {
        String? error;

        if (value!.isEmpty) {
          error = 'Please enter your password';
        } else if (value != _passwordCtrl.text) {
          error = 'Passwords did not match';
        }

        return error;
      },
    );
  }

  Widget signUpBtn() {
    return Container(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();
            Utils.showSnackBar(
              context,
              "Signing up...",
              duration: Duration(days: 365),
            );

            try {
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: _emailCtrl.text,
                password: _passwordCtrl.text,
              );

              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (Route<dynamic> route) => false);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                Utils.showSnackBar(context, "Password is too weak");
              } else if (e.code == 'email-already-in-use') {
                Utils.showSnackBar(context, "Email already exists");
              }
            } catch (e) {
              print('Error: $e');
            }
          }
        },
        child: Text('Submit'.toUpperCase()),
      ),
    );
  }
}
