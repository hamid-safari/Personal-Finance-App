import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_finance/screen/transactionpage.dart';
import 'package:personal_finance/util/colour.dart';

import '../main.dart';
import 'account.dart';
import 'categories.dart';
import 'overview.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

var _currentIndex=0;
var _totalbalance=0;
List<Widget> page_list = List();

final FirebaseAuth _auth = FirebaseAuth.instance;

@override
  void initState() {
  page_list.add(Account());
  page_list.add(Categories());
  page_list.add(TransactionPage());
  page_list.add(Overview());
//
  }
// int onTotalBalance(){
//     setState(() {
//       _totalbalance=this;
//     });
//  Text('178',style: TextStyle(fontSize: 19.0)
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colour.primary,
        title: Container(
          //   width: MediaQuery.of(context).size.width,
         child: Column(
           children: [
             SizedBox(height: 2.0,),
             Text('All acounts',style: TextStyle(fontSize: 15.0)),
             SizedBox(height: 5.0,),
             StreamBuilder(
                 stream: Account.Total_Subject,
                 builder: (context,snapshot){
                        if(snapshot.hasData){
                          return Text('${snapshot.data}',style: TextStyle(fontSize: 19.0));
                        }else{
                          return Container();
                        }
                 }
             ),
           ],
         ),
        ),


      ),
      drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Column(
                    children: [
                      Text('Your acount',
                          style:  GoogleFonts.lato(textStyle:TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white

                          ))
                      ),
                      SizedBox(height: 10.0,),
                      Text(_auth.currentUser.email,
                          style:  GoogleFonts.lato(textStyle:TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white

                          ))
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colour.primary,
                ),
              ),
              ListTile(
                title: Text('Contact us'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Sign out'),
                onTap: () {

                  _auth.signOut().then((value) => {
                  Navigator.pushReplacement (context, MaterialPageRoute(builder: (context)=>MyApp()))

                  });

                  // ...
                },
              ),
            ],
          ),// Populate the Drawer in the next step.
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
        selectedItemColor: Colour.primary,
        currentIndex: _currentIndex,
        unselectedItemColor: Colour.grey_bottom,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Acounts',
            icon: Icon(Icons.payment),
          ),
          BottomNavigationBarItem(
            label: 'Categories',
            icon: Icon(Icons.blur_circular),
          ),
          BottomNavigationBarItem(
            label: 'Transactions',
            icon: Icon(Icons.money),
          ),
          BottomNavigationBarItem(
            label: 'Overview',
            icon: Icon(Icons.stacked_bar_chart),
          ),
        ],
      ),
      body: Container(
        child: page_list[_currentIndex],
      ),
    );
  }
}
