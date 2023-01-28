import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/event/addcard_event.dart';
import 'package:personal_finance/event/addcategory_event.dart';
import 'package:personal_finance/state/addcard_state.dart';
import 'package:personal_finance/state/addcategory_state.dart';

// part '../event/addcard_event.dart';
// part '../state/addcard_state.dart';

class AddCategoryBloc  extends Bloc<AddcategoryEvent,AddCategoryState> {

  var title,doc_id;
  var codepoint;
  var fontfamily;
 // var fontpackage;
  CollectionReference firestoreInstance = FirebaseFirestore.instance.collection('category');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var context;
  AddCategoryBloc(this.context) : super(InitialAddCategory());



  void onNewcategoryEventError() {
    add(NewCategoryEventError());
  }
  void onDelete(var id) {
    doc_id=id;
    add(DeletecategoryEvent());
  }
  void onNewcategoryEventSuccess() {
    add(NewcategoryEventSuccess());
  }
  void onNewcategoryInit() {
    add(NewcategoryInit());
  }

  void onNewcategoryEvent(String _title, var _codepoint,var _fontfamily) {
    title=_title;
    codepoint=_codepoint;
    fontfamily=_fontfamily;
   // fontpackage=_fontpackage;
    add(NewcategoryEvent());
  }
  void onUpdatecategoryEventSuccesfull(var title, var balance,var id) {
    title=title;
    doc_id=id;
    //_balance=balance;
    add(UpdatecategoryEventSuccesfull ());
  }

  // @override
  // // TODO: implement initialState
  // AddCardState get initialState => LoadingAddCard();

  @override
  Stream<AddCategoryState> mapEventToState(AddcategoryEvent event) async* {
    // TODO: implement mapEventToState
    if (event is NewcategoryEventSuccess) {
      yield SentAddCategory();
      Future.delayed( Duration(milliseconds: 1600),(){
        onNewcategoryInit();
        Navigator.pop(context);
      });
    } else if (event is NewCategoryEventError) {
      yield ErrorAddCategory();
    } else if(event is NewcategoryInit){
      yield InitialAddCategory();
    }
    else if(event is DeletecategoryEvent){
      DeleteCart(doc_id);
    }
    else if(event is UpdatecategoryEventSuccesfull){
      yield LoadingAddCategory();
     // Updatecard(_title,_balance,doc_id);
    }
    else if(event is NewcategoryEvent){
      //LoadingAddCard();
      print("Add cat event");
      yield LoadingAddCategory();
      AddCategory(title,codepoint,fontfamily);
    }
  }
  /*
  Delete category method
   */
  void DeleteCart(String doc_id)async{
    if(doc_id.length>3){
      firestoreInstance.doc(doc_id).delete()
          .then((value) {
        print("------- Deleted ------");
        onNewcategoryEventSuccess();
      })
          .catchError((ev){
        print("error: ${onError}");
        onNewcategoryEventError();
      })
      ;
    }else{
      onNewcategoryEventError();
    }

  }
  void AddCategory(String title, var codepoint,var fontfamily,) async {

    print("Add cat method");
    return firestoreInstance.add({
      "email": _auth.currentUser.email,
      "title": title,
      "codePoint":codepoint,
      "fontFamily":fontfamily

    }).then((value) {
      print("category added");
      onNewcategoryEventSuccess();
    }).catchError((onError) {
      print("error: ${onError}");
      onNewcategoryEventError();
    });



  }


}
