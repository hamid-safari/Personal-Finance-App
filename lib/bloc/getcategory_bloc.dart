import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/event/getcategory_event.dart';
import 'package:personal_finance/model/card.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/screen/categories.dart';
import 'package:personal_finance/state/getcategory_state.dart';

class GetCategorylistBloc extends Bloc<GetCategoryListEvent,GetCategoryListState>{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //DateTime now;
  var _date;
  final firestoreInstance = FirebaseFirestore.instance.collection("category");
  final firestoreInstance_transaction = FirebaseFirestore.instance.collection("transaction");
  HashMap<String,int> translist = HashMap();
  GetCategorylistBloc() : super(InitialGetCategoryList());

  void onLoading(var date){
    _date=date;
    add(LoadingCategoryListEvent());
  }
  void onCardListSuccess(){
    add(GetCategoryListSuccess());
  }

  @override
  Stream<GetCategoryListState> mapEventToState(GetCategoryListEvent event
      ) async*{
   // now = new DateTime.now();

    if (event is GetCategoryListSuccess){

    }else if (event is LoadingCategoryListEvent){
      yield LoadingGetCardList();
   //   var mystream= _catlist();
      var mystream= _translist(_date);
      print("----------Loading category---------");

      if(mystream !=null){
        print("------retrived category");
        print("------size: ${mystream}");
        yield RetrivedCategoryList(mystream);

      }else{
        print("------Get error category");
        print("------size: ${mystream.length}");
        add(GetCategoryListErrorEvent());
      }
    }
    else{
      // Error event
      print("----------empty category");
      yield EmptyCategoryList();
    }
  }

  Stream<QuerySnapshot> _catlist(){

    try{
      print("------ getting category");
      var v = firestoreInstance.where('email',isEqualTo: _auth.currentUser.email).snapshots();
//print("For each:-------");
      // v.forEach((element) {
      //   for(int i =0;i<element.size;i++){
      //     cat = Category.fromSnapshot(element.docs[i]);
      //     print(element.docs.first);
      //     print(cat.title);
      //
      //   }
      //
      // });
      //_translist('25-1-2021',v);
      return v;
    }catch(e){
      print("nullll Category List!!!!");
      return null;
    }

  }
  Stream<QuerySnapshot> _translist(var date){
    translist.clear();
    var hash_temp;
    Transactions trans;
    try{
      print("------ getting Trans");
      var v = firestoreInstance_transaction.where('email',isEqualTo: _auth.currentUser.email)
          .where('fulldate',isEqualTo:date).snapshots();


v.forEach((element) {
    for(int i =0;i<element.size;i++){
      trans = Transactions.fromSnapshot(element.docs[i]);
      if(translist.containsKey(trans.category)){
        hash_temp = translist[trans.category];
        translist[trans.category]= hash_temp+trans.price;
      }else{
        translist[trans.category]= trans.price;
      }
      print('-----------------------------------------------');
      print(trans.category);


    }

});
     var value =  _catlist();

      Categories.Trans_Subject.add(translist);
      return value;
    }catch(e){
      print("nullll Category List!!!!");
      return null;
    }

  }
}