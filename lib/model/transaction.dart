import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions{
  int _price,_day,_month,_year;
  String _id, _email,_category,_title,_date,_fulldate,_acount;

  Transactions(this._id, this._price, this._day, this._month, this._year,
      this._email, this._category, this._title, this._date, this._fulldate,this._acount);



  static Transactions fromSnapshot(DocumentSnapshot snap) {
    return Transactions(

      snap.id,
      snap.data()['price'],
      snap.data()['day'],
      snap.data()['month'],
      snap.data()['year'],
      snap.data()['email'],
      snap.data()['category'],
      snap.data()['title'],
      snap.data()['date'],
      snap.data()['fulldate'],
      snap.data()['account'],



    );
  }

  Map<String, Object> toDocument() {
    return {
      'title': _title,
      'price': _price,
      'email': _email,
      'day': _day,
      'month': _month,
      'year': _year,
      'category': _category,
      'date': _date,
      'fulldate': _fulldate,
      'account': acount,
    };
  }
  get fulldate => _fulldate;

  set fulldate(value) {
    _fulldate = value;
  }

  get acount => _acount;

  set acount(value) {
    _acount = value;
  }

  get date => _date;

  set date(value) {
    _date = value;
  }

  get title => _title;

  set title(value) {
    _title = value;
  }

  get category => _category;

  set category(value) {
    _category = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  get year => _year;

  set year(value) {
    _year = value;
  }

  get month => _month;

  set month(value) {
    _month = value;
  }

  get day => _day;

  set day(value) {
    _day = value;
  }

  get price => _price;

  set price(value) {
    _price = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
