import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/event/addcard_event.dart';
import 'package:personal_finance/event/addcategory_event.dart';
import 'package:personal_finance/event/addtransaction_event.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/screen/transaction_screen.dart';
import 'package:personal_finance/state/addcard_state.dart';
import 'package:personal_finance/state/addcategory_state.dart';
import 'package:personal_finance/state/addtransaction_state.dart';


class AddTransactionBloc  extends Bloc<AddTransactionEvent,AddTransactionState> {

  Transactions transaction;
  ListItem listItem;
  // var fontpackage;
  CollectionReference firestoreInstance = FirebaseFirestore.instance.collection('transaction');
  CollectionReference cardsinstance = FirebaseFirestore.instance.collection('cards');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AddTransactionBloc() : super(InitialAddTransaction());



  void onNewcategoryEventError() {
    add(NewTransactionEventError());
  }

  void onNewcategoryEventSuccess() {
    add(NewTransactionEventSuccess());
  }
  void onNewcategoryInit() {
    add(NewTransactionInit());
  }

  void onNewcategoryEvent(Transactions trans,ListItem _listItem) {
    transaction=trans;
    listItem=_listItem;

    // fontpackage=_fontpackage;
    add(NewTransactionEvent());
  }




  @override
  Stream<AddTransactionState> mapEventToState(AddTransactionEvent event) async* {
    // TODO: implement mapEventToState
    if (event is NewTransactionEventSuccess) {
      yield SentAddTransaction();
      Future.delayed( Duration(milliseconds: 1600),(){
        onNewcategoryInit();
      });
    } else if (event is NewTransactionEventError) {
      yield ErrorAddTransaction();
    } else if(event is NewTransactionInit){
      yield InitialAddTransaction();
    }


    else {

      print("Add transaction event");
      yield LoadingAddTransaction();
     // AddTransaction(transaction);
      Updatecard(listItem.value,transaction.price);
    }
  }

  void AddTransaction(Transactions trans) async {
    //trans.acount=listItem.name;
    //print("${trans.toDocument()}");
    print("Add transaction method");
    return firestoreInstance.add(trans.toDocument()).then((value) {
      print("transaction added");
      onNewcategoryEventSuccess();
    }).catchError((onError) {
      print("error: ${onError}");
      onNewcategoryEventError();
    });



  }

  void Updatecard(var currentprice,var newprice) async {
    var price = currentprice-newprice;
    cardsinstance.doc(listItem.id).update({
      "email": _auth.currentUser.email,
      "title": transaction.acount,
      "balance": price.toString()
    }).then((value) {
      print("card added");
      AddTransaction(transaction);
    }).catchError((onError) {
      print("error: ${onError}");

    });


  }
}
