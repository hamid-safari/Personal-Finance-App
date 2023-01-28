import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/event/gettransaction_event.dart';
import 'package:personal_finance/model/card.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/screen/categories.dart';
import 'package:personal_finance/state/gettransaction_state.dart';

class GetTransactionlistBloc extends Bloc<GetTransactionEvent,GetTransactionListState>{

  final FirebaseAuth _auth = FirebaseAuth.instance;


  final firestoreInstance_transaction = FirebaseFirestore.instance.collection("transaction");

  GetTransactionlistBloc() : super(InitialGetTransactionList());

  void onLoading(){

    add(LoadingTransactionListEvent());
  }
  void onCardListSuccess(){
    add(GetTransactionListSuccess());
  }

  @override
  Stream<GetTransactionListState> mapEventToState(GetTransactionEvent event
      ) async*{
    // now = new DateTime.now();

    if (event is GetTransactionListInit){
      yield InitialGetTransactionList();

    }else if (event is LoadingTransactionListEvent){
      yield LoadingGetTransactionList();

      var mystream= _translist();


      if(mystream !=null){

        yield RetrivedTransactionList(mystream);

      }else{


        add(GetTransactionListErrorEvent());
      }
    }
    else{
      // Error event
      print("----------empty category");
      yield EmptyTransactionList();
    }
  }

  Stream<QuerySnapshot> _translist(){

    try{
      var v = firestoreInstance_transaction.where('email',isEqualTo: _auth.currentUser.email)
          .orderBy('fulldate', descending: true)
          .snapshots();


      return v;
    }catch(e){
      print("nullll Category List!!!!");
      return null;
    }

  }
}