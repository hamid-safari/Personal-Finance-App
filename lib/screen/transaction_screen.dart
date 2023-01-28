import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_finance/bloc/addtransaction_bloc.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/state/addtransaction_state.dart';
import 'package:personal_finance/util/colour.dart';
import 'package:personal_finance/widget/button_widget.dart';
import 'package:rxdart/rxdart.dart';

import 'account.dart';

class TransActionScreen extends StatefulWidget {
  Category category;
  static BehaviorSubject<int> Price_Subject = BehaviorSubject<int>();
  TransActionScreen(this.category);

  @override
  _TransActionScreenState createState() => _TransActionScreenState();
}

class _TransActionScreenState extends State<TransActionScreen> {

  var price_controller = TextEditingController();
  var note_controller = TextEditingController();
  var _bloc = AddTransactionBloc();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Transactions transactions;
  DateTime now;
  var fulldate;
  List<ListItem> _dropdownItems =List();
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;
  var havecard = true;
  @override
  void initState() {
    // TODO: implement initState
     now = new DateTime.now();

     if(Account.Cardlist.isNotEmpty){
       for(int i=0;i<Account.Cardlist.length;i++){
         _dropdownItems.add(ListItem(Account.Cardlist[i].balance,Account.Cardlist[i].title,Account.Cardlist[i].id));
       }

       TransActionScreen.Price_Subject.add(0);
       _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
       _selectedItem = _dropdownMenuItems[0].value;
     }else{
       havecard=false;
     }

  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  void BlocCallBack(){


var error = '';
    showDialog(context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder:(context,setState){
              return Dialog(
                child: Container(
                 // height: MediaQuery.of(context).size.height/2.3,
                  padding: EdgeInsets.all(18.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 15.0,),
                      Container(
                        
                          child:Text("Select account",
                            style: GoogleFonts.lato(textStyle:TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff314670)

                            )),)
                      ),
                      SizedBox(height: 40.0,),
                      Container(
                       color: Color(0xff63759d),
                        padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 25.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ListItem>(

                              value: _selectedItem,
                              hint: Text(_selectedItem.name),
                              items: _dropdownMenuItems,
                              style: GoogleFonts.lato(textStyle:TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white

                              )),
                              dropdownColor:Color(0xff63759d) ,
                              isDense: true,
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.white,
                              onChanged: (value) {

                                setState(() {
                                  print("value: ${value.name}:${value.value}");
                                  _selectedItem = value;
                                });
                              }),
                        ),
                      ),
                      SizedBox(height: 40.0,),
                      Container(
                        alignment: Alignment.center,
                        child: MaterialButton(

                          elevation: 2.0,
                          shape:  RoundedRectangleBorder(side: BorderSide(
                              color: Color(0xff63759d),
                              width: 2,
                              style: BorderStyle.solid
                          ), borderRadius: BorderRadius.circular(50)),
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 25.0),
                            onPressed: (){

                            if(TransActionScreen.Price_Subject.value>_selectedItem.value){
                              setState(() {
                                error='You do not have enough money in this account!';
                              });
                            }
                            else if(note_controller.text==null || note_controller.text.isEmpty){
                              setState(() {
                                error='Add a note';
                              });
                            }
                            else{
                              fulldate = '${now.day}-${now.month}-${now.year}';
                              transactions = Transactions('0', TransActionScreen.Price_Subject.value, now.day, now.month, now.year,
                                  _auth.currentUser.email, widget.category.title, note_controller.text, '12Dec', fulldate,_selectedItem.name);
                              _bloc.onNewcategoryEvent(transactions,_selectedItem);
                              print('${_selectedItem.value}-${_selectedItem.name}-${_selectedItem.id}');
                              Navigator.pop(context);
                            }
                            },
                        child: Text('Add transaction'
                        ,style:  GoogleFonts.lato(textStyle:TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black

                          )),),),
                      ),
                      SizedBox(height: 15.0,),
                      Text(error,
                      style: GoogleFonts.lato(textStyle:TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent

                      )),)
                    ],
                  ),
                ),
              );
            }
          );
        }
    );


   // print("year: ${now.}");
    //fulldate = '${now.day}-${now.month}-${now.year}';
    //transactions = Transactions('0', TransActionScreen.Price_Subject.value, now.day, now.month, now.year,
    //    _auth.currentUser.email, widget.category.title, note_controller.text, '12Dec', fulldate);
 // _bloc.onNewcategoryEvent(transactions);
  }

  @override
  Widget build(BuildContext context) {

    /*
    screen main elements
     */
    Widget Initwidget(){
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Transfer amount'
                  ,style: GoogleFonts.lato(
                      textStyle:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600)),),
                SizedBox(height: 10.0,),
                Row(
                  children: [
                    Text('Category:'
                      ,style: GoogleFonts.lato(
                          textStyle:
                          TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),),
                    SizedBox(width: 10.0,),
                    Text(widget.category.title
                      ,style: GoogleFonts.lato(
                          textStyle:
                          TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,color: Colour.primary)),),
                  ],
                ),
                /*
                        Price textfield
                         */
                StreamBuilder(
                    stream: TransActionScreen.Price_Subject,
                    builder: (context, snapshot) {
                      price_controller.text=snapshot.data.toString();
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 15.0),
                        child: TextField(
                          autofocus: false,
                          enabled: false,
                          controller: price_controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.lato(
                              textStyle:
                              TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600,color: Colors.black)),
                          decoration: InputDecoration(

                              hintText: 'Amount',
                              hintStyle: GoogleFonts.lato(
                                  textStyle:
                                  TextStyle(fontSize: 26.0, fontWeight: FontWeight.w600,color: Colors.blueGrey))
                          ),
                        ),
                      );
                    }
                ),

                /*
                        Note textfield
                         */
                Container(
                  //height: 40.0,
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  child: TextField(
                    maxLines: 2,
                    controller: note_controller,
                    style: GoogleFonts.lato(
                        textStyle:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500,color: Colors.black)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Note...',
                        hintStyle: GoogleFonts.lato(
                            textStyle:
                            TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500,color: Colors.blueGrey))
                    ),
                  ),
                ),

              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0,
                vertical: 8.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonWidget('1'),
                ButtonWidget('2'),
                ButtonWidget('3'),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0,
                vertical: 2.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonWidget('4'),
                ButtonWidget('5'),
                ButtonWidget('6'),
              ],
            ),

          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0,
                vertical: 2.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonWidget('7'),
                ButtonWidget('8'),
                ButtonWidget('9'),
              ],
            ),

          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0,
                vertical: 2.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonWidget(Icon(Icons.remove,size: 40.0,),color: Colors.white,),
                ButtonWidget('0'),
                ButtonWidget(Icon(Icons.check,size: 40.0,color: Colors.white,),color:Colour.check_green,blocCallback: BlocCallBack,),
              ],
            ),

          )
        ],
      );
    }

    /*
    check card and return related widget
     */
    Widget ChechHavecard(){
      if(havecard){
        return Initwidget();
      }else{

        return Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.6),
          child: Center(
            child: Text("Please add an account first",
            style:  GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.redAccent,
                    fontSize: 19.0, fontWeight: FontWeight.w600)),),
          ),
        );
      }
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,

          color: Color(0xfff6f6f5),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.0,vertical: 10.0),
                  child: Text('New Transactions'
                    ,style: GoogleFonts.lato(
                        textStyle:
                        TextStyle(fontSize: 19.0, fontWeight: FontWeight.w600)),),
                ),
                SizedBox(height: 15.0,),


                BlocBuilder<AddTransactionBloc,AddTransactionState>(
                  cubit: _bloc,
                  builder: (context,state){
                    if(state is InitialAddTransaction){
                      return ChechHavecard();
                    }else if(state is LoadingAddTransaction){
                      return  Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 35.0),
                        child: CircularProgressIndicator(),
                      );
                    }else if(state is SentAddTransaction){
                      return  Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 35.0),
                        child: Text("Done...",
                            style:GoogleFonts.lato(textStyle:TextStyle(
                                fontSize: 18.0,

                                fontWeight: FontWeight.bold,
                                color: Color(0xff19ad78)
                            ))),
                      );
                    }else
                    {
                      return  Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 35.0),
                        child: Text("Error...",
                            style:GoogleFonts.lato(textStyle:TextStyle(
                                fontSize: 18.0,

                                fontWeight: FontWeight.bold,
                                color: Color(0xffff5466)
                            ))),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
class ListItem {
  int value;
  String name,id;

  ListItem(this.value, this.name,this.id);
}