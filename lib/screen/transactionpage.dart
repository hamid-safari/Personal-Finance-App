import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_finance/bloc/gettransaction_bloc.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/state/gettransaction_state.dart';
import 'package:personal_finance/widget/transaction_widget.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<TransactionPage> {
  var _bloc = GetTransactionlistBloc();

  @override
  void initState() {
    // TODO: implement initState
    _bloc.onLoading();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Last Transactions',
            style:  GoogleFonts.lato(textStyle:TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.w600

            )),),
            margin: EdgeInsets.symmetric(vertical: 12.0,horizontal: 12.0),
          ),
          Expanded(
            child: BlocBuilder<GetTransactionlistBloc,GetTransactionListState>(
              cubit: _bloc,
              builder: (context,state){
                if(state is LoadingGetTransactionList || state is InitialGetTransactionList){
                  return CircularProgressIndicator();
                }else if(state is RetrivedTransactionList){
                  return Translistwidget(state.translist);
                }else if(state is EmptyTransactionList){
                  return Center(
                    child: Text('There is no transactions',
                        style:  GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 19.0, fontWeight: FontWeight.w600))),
                  );
                }else {
                  return Center(
                    child: Text('Error'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget Translistwidget(Stream<QuerySnapshot> translist) {
    return StreamBuilder<QuerySnapshot>(
        stream: translist,
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.size==0){
              return    Center(
                child: Text('There is no transactions',style:  GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 19.0, fontWeight: FontWeight.w600))),
              );
            }else{
              final List<Transactions> children = snapshot.data.docs.map((doc) {
                var _card = Transactions.fromSnapshot(doc);
                //print("totla: $total_balance");
                return _card;
              }).toList();

              return Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: ListView.builder(
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      return  TransactionWidget(children[index],

                      );
                    }),
              );
            }
          }else{
            return    Center(
              child: Text('There is no transactions'),
            );
          }
        }
    );
  }
}
