import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/event/addcard_event.dart';
import 'package:personal_finance/state/addcard_state.dart';

// part '../event/addcard_event.dart';
// part '../state/addcard_state.dart';

class AddCardBloc  extends Bloc<AddcardEvent,AddCardState> {

  var _title,_balance,doc_id;
  CollectionReference firestoreInstance = FirebaseFirestore.instance.collection('cards');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var context;
  AddCardBloc() : super(InitialAddCard());



  void onNewCardEventError() {
    add(NewCardEventError());
  }
  void onDelete(var id) {
    doc_id=id;
    add(DeleteCardEvent());
  }
  void onNewCardEventSuccess() {
    add(NewCardEventSuccess());
  }
  void onNewCardInit() {
    add(NewCardInit());
  }

  void onNewCardEvent(var title, var balance) {
    _title=title;
    _balance=balance;
    add(NewCardEvent());
  }
  void onUpdateCardEventSuccesfull(var title, var balance,var id) {
    _title=title;
    doc_id=id;
    _balance=balance;
    add(UpdateCardEventSuccesfull ());
  }

  // @override
  // // TODO: implement initialState
  // AddCardState get initialState => LoadingAddCard();

  @override
  Stream<AddCardState> mapEventToState(AddcardEvent event) async* {
    // TODO: implement mapEventToState
    if (event is NewCardEventSuccess) {
      yield SentAddCard();
      Future.delayed( Duration(milliseconds: 1600),(){
        onNewCardInit();

      });
    } else if (event is NewCardEventError) {
      yield ErrorAddCard();
    } else if(event is NewCardInit){
      yield InitialAddCard();
    }
    else if(event is DeleteCardEvent){
      DeleteCart(doc_id);
    }
    else if(event is UpdateCardEventSuccesfull){
      yield LoadingAddCard();
      Updatecard(_title,_balance,doc_id);
    }
    else {
      //LoadingAddCard();
      yield LoadingAddCard();
      Addcard(_title,_balance);
    }
  }

  void Addcard(String title, var balance) async {

    return firestoreInstance.add({
      "email": _auth.currentUser.email,
      "title": title,
      "balance": balance
    }).then((value) {
      print("card added");
      onNewCardEventSuccess();
    }).catchError((onError) {
      print("error: ${onError}");
      onNewCardEventError();
    });



  }
  void Updatecard(String title, var balance,String doc_id) async {
    firestoreInstance.doc(doc_id).update({
      "email": _auth.currentUser.email,
      "title": title,
      "balance": balance
    }).then((value) {
      print("card added");
      onNewCardEventSuccess();
    }).catchError((onError) {
      print("error: ${onError}");
      onNewCardEventError();
    });


  }
  //
  void DeleteCart(String doc_id)async{
    if(doc_id.length>3){
      firestoreInstance.doc(doc_id).delete()
          .then((value) {
        print("------- Deleted ------");
        onNewCardEventSuccess();
      })
          .catchError((ev){
        print("error: ${onError}");
        onNewCardEventError();
      })
      ;
    }else{
      onNewCardEventError();
    }

  }

}
