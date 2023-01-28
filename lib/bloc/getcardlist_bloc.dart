import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/event/getcardlist_event.dart';
import 'package:personal_finance/model/card.dart';
import 'package:personal_finance/state/getcardlist_state.dart';

class GetCardlistBloc extends Bloc<GetCardListEvent,GetCardListState>{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final firestoreInstance = FirebaseFirestore.instance.collection("cards");

  GetCardlistBloc() : super(InitialGetCardList());

  void onLoading(){
    add(LoadingCardListEvent());
  }
  void onCardListSuccess(){
    add(GetCardListSuccess());
  }

  @override
  Stream<GetCardListState> mapEventToState(GetCardListEvent event
      ) async*{

    if (event is GetCardListSuccess){

    }else if (event is LoadingCardListEvent){
      yield LoadingGetCardList();
      var mystream= _cardlist();
     print("----------Loading---------");

     if(mystream !=null){
       print("------retrived");
       print("------size: ${mystream}");
       yield RetrivedGetCardList(mystream);

     }else{
       print("------Get error");
       print("------size: ${mystream.length}");
       add(GetCardListErrorEvent());
     }
    }
    else{
      // Error event
      print("----------empty");
      yield EmptyCardList();
    }
  }

  Stream<QuerySnapshot> _cardlist(){

    try{
      print("OOOOOOOOOOOO KKKKKKKKKKKK");
     var v = firestoreInstance.where('email',isEqualTo: _auth.currentUser.email).snapshots();
     // v.forEach((element) {
     //   //element.docs.length
     //     var a=  Cards.fromSnapshot(element.docs[1]);
     //       print("-----cards: ${a.title}");
     // });
     // onCardListSuccess();
      return v;
    }catch(e){
      print("nullll CARD List!!!!");
      return null;
    }

  }
}