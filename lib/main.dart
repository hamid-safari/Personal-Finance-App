import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/screen/first_screen.dart';
import 'package:personal_finance/signup_page.dart';

import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<Widget> page_list = List();
  var current_page = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState

    page_list.add(SignUp(registercallback: onRegister,onsuccess: onSingupSuccess,));
    page_list.add(LoginPage(onsuccess:onSingupSuccess,logincallback:onLogin));
    page_list.add(FirstScreen());
    CheckUser();
  }
  void CheckUser() {
    User user = _auth.currentUser;
    if (user != null) {
      setState(() {
        current_page=2;
      });

    }
  }
  void onRegister(){
    setState(() {
      current_page=1;
    });
  }
  void onLogin(){
    setState(() {
      current_page=0;
    });
  }
  void onSingupSuccess(){
    setState(() {
      current_page=2;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: page_list[current_page],
    );
  }
}
