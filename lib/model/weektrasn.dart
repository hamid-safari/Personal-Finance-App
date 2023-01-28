class WeekTrans{
  String title;
  int price;
  double percent;

  WeekTrans(this.title, this.price, this.percent);

  factory WeekTrans.fromJson(Map<String, dynamic> parsedJson) {
    return WeekTrans(
      parsedJson['year'].toString(),
      parsedJson['sales'] as int,
      parsedJson['sales'] as double,
    );
  }
}