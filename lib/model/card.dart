import 'package:cloud_firestore/cloud_firestore.dart';

class Cards{
  String _id,_title;
  int _balance;

  Cards(this._id, this._title, this._balance);

  int get balance => _balance;

  set balance(int value) {
    _balance = value;
  }

  get title => _title;

  set title(value) {
    _title = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  static Cards fromJson(Map<String, Object> json) {
    return Cards(

      json['id'] as String,
        json['title'] as String,
      json['balance'] as int
    );
  }

  static Cards fromSnapshot(DocumentSnapshot snap) {
    return Cards(

      snap.id,
      snap.data()['title'],
      int.parse(snap.data()['balance']),
    );
  }

  Map<String, Object> toDocument(var email) {
    return {
      'title': _title,
      'balance': _balance,
      'email': email,
    };
  }
}