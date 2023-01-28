
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category{

  String _id,_title,_amount,_fontFamily;
  int _balance,_codepoint;


  Category(this._balance,this._id,this._codepoint,this._fontFamily,this._title);

  static Category fromJson(Map<String, Object> json) {
    return Category(

        json['balance'] as int,
        json['id'] as String,
        json['codePoint'] as int,
        json['fontFamily'] as String,
        json['title'] as String,
    );
  }
  static Category fromSnapshot(DocumentSnapshot snap) {
    return Category(
      0,
      snap.id,
      snap.data()['codePoint'],
      snap.data()['fontFamily'],
      snap.data()['title'],



    );
  }
  Map<String, Object> toDocument(var email) {
    return {
      'title': _title,
      //'balance': _balance,
      'email': email,
      'fontFamily': _fontFamily,
      'codePoint': _codepoint,
    };
  }
  get fontFamily => _fontFamily;

  set fontFamily(value) {
    _fontFamily = value;
  }
  set amount(value) {
    _amount = value;
  }

  get amount => _amount;



  get title => _title;

  set title(value) {
    _title = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
  int get balance => _balance;

  set balance(int value) {
    _balance = value;
  }

  get codepoint => _codepoint;

  set codepoint(value) {
    _codepoint = value;
  }
}