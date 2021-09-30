import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fund_monitoring/app_states/selected_fund.dart';
import 'package:fund_monitoring/screens/expense_form_screen.dart';
import 'package:fund_monitoring/screens/expense_types/expense_types_screen.dart';
import 'package:fund_monitoring/screens/fund_details/fund_details_screen.dart';
import 'package:fund_monitoring/screens/fund_form_screen.dart';
import 'package:fund_monitoring/screens/funds_screen.dart';
import 'package:fund_monitoring/screens/login_screen.dart';
import 'package:fund_monitoring/screens/signup_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(InitFlutterFire());
}

class InitFlutterFire extends StatefulWidget {
  const InitFlutterFire({Key? key}) : super(key: key);

  @override
  _InitFlutterFireState createState() => _InitFlutterFireState();
}

class _InitFlutterFireState extends State<InitFlutterFire> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error.toString()}");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp();
          }

          return Text("Loading...", textDirection: TextDirection.ltr,);
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SelectedFund()),
      ],
      child: MaterialApp(
        title: 'Fund Monitoring',
        initialRoute: (user != null) ? '/funds' : '/log-in',
        debugShowCheckedModeBanner: false,
        routes: {
          '/log-in': (context) => LoginScreen(),
          '/sign-up': (context) => SignUpScreen(),
          '/funds': (context) => FundsScreen(),
          '/expense-types': (context) => ExpenseTypeScreen(),
          '/fund-form': (context) => FundFormScreen(),
          '/fund-details': (context) => FundDetailsScreen(),
          '/expense-form': (context) => ExpenseFormScreen(),
        },
      ),
    );
  }
}
