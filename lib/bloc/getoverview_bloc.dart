import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/event/gettransaction_event.dart';
import 'package:personal_finance/model/card.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/screen/categories.dart';
import 'package:personal_finance/screen/overview.dart';
import 'package:personal_finance/state/gettransaction_state.dart';

class GetOverviewBloc extends Bloc<GetTransactionEvent,GetTransactionListState>{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  DateTime now;
  final firestoreInstance_transaction = FirebaseFirestore.instance.collection("transaction");
  HashMap<int,int> trans_daily = HashMap();
  HashMap<String,int> category_weekly = HashMap();
var start,end;
  GetOverviewBloc() : super(InitialGetTransactionList());

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
    now = new DateTime.now();
    trans_daily.clear();
    category_weekly.clear();
    Transactions trans;

    end = '${now.day}-${now.month}-${now.year}';
    var hash_temp;
    var temp;
    /*
    check current day is less than 7th or not
     */
    try{
      if(now.day<=6){
        start = '1-${now.month}-${now.year}';
        for(int i=1;i<=now.day;i++){
          trans_daily[i]=0;
        }

      }else{
         temp = now.day-7;
        start = '$temp-${now.month}-${now.year}';
        for(int i=temp;i<=now.day;i++){
          trans_daily[i]=0;
        }
      }
      print("start: $start");
      print("end: $end");

      // query get data
      var v = firestoreInstance_transaction.where('email',isEqualTo: _auth.currentUser.email)
          .where('fulldate', isGreaterThanOrEqualTo: start)
          .where('fulldate', isLessThanOrEqualTo: end)
          .snapshots();

      // looop on fetched data
      v.forEach((element) {
        for(int i =0;i<element.size;i++){
          trans = Transactions.fromSnapshot(element.docs[i]);
          print("trans: ${trans.title}");

          //for chart
          if(trans_daily.containsKey(trans.day)){
            hash_temp = trans_daily[trans.day];
            trans_daily[trans.day]= hash_temp+trans.price;
          }else{
            trans_daily[trans.day]= trans.price;
          }

          //for category transaction sum
          if(category_weekly.containsKey(trans.category)){
            hash_temp = category_weekly[trans.category];
            category_weekly[trans.category]= hash_temp+trans.price;
          }else{
            category_weekly[trans.category]= trans.price;
          }
        }

      });

      Overview.TransDaily_Subject.add(trans_daily);
      Overview.Transweekly_Subject.add(category_weekly);

      return v;

    }catch(e){
      print("nullll Category List!!!!");
      return null;
    }

  }
}