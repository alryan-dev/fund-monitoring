import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log-in")),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            emailField(),
            SizedBox(height: 15),
            passwordField(),
            SizedBox(height: 15),
            loginBtn(),
            SizedBox(height: 10),
            registerBtn(),
          ],
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

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordCtrl,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      validator: (value) => (value!.isEmpty) ? 'Please enter password' : null,
    );
  }

  Widget loginBtn() {
    return Container(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();
            Utils.showSnackBar(context, "Logging in...", duration: Duration(days: 365));

            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _emailCtrl.text,
                password: _passwordCtrl.text,
              );

              Navigator.pushReplacementNamed(context, '/funds');
              ScaffoldMessenger.of(context).removeCurrentSnackBar();

            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                Utils.showSnackBar(context, "Email does not exist");
              } else if (e.code == 'wrong-password') {
                Utils.showSnackBar(context, "Wrong password");
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

  Widget registerBtn() {
    return Container(
      width: double.infinity,
      height: 40,
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, '/sign-up'),
        child: Text('Sign-up'.toUpperCase()),
      ),
    );
  }
}
