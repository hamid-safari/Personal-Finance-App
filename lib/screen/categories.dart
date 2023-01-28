import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:personal_finance/bloc/getcategory_bloc.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/serialize/iconserialize.dart';
import 'package:personal_finance/state/getcategory_state.dart';
import 'package:personal_finance/util/colour.dart';
import 'package:personal_finance/util/timeconvert.dart';
import 'package:personal_finance/widget/category_widget.dart';
import 'package:rxdart/rxdart.dart';

class Categories extends StatefulWidget {
  static BehaviorSubject<HashMap<String,int>> Trans_Subject = BehaviorSubject<HashMap<String,int>>();

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  var icondata = IconData( 58756,fontFamily:'MaterialIcons');

  static BehaviorSubject<Icon> Total_Subject = BehaviorSubject<Icon>();

  var _bloc = GetCategorylistBloc();
  List<Category> cat_list = List();
  List<Color> color_list = List();
  Icon _icon;
  var sum;
  var cat_title_controller = TextEditingController();
  String month_year,day;
  DateTime now;
  @override
  void initState() {
    //month_year
    _icon= Icon(Icons.add_circle_outline,size: 35.0,);
    Total_Subject.add(_icon);
    now = new DateTime.now();
    month_year= TimeConvert.FullMonthName(now.month)+' ${now.year}';
    day=now.day.toString();
    cat_list.add(Category(0,'id',58727,'MaterialIcons, ','Add'));
    cat_list.add(Category(0,'id',58727,'MaterialIcons, ','Add'));
    cat_list.add(Category(0,'id',58727,'MaterialIcons, ','Add'));
    cat_list.add(Category(0,'id',58727,'MaterialIcons, ','Add'));
    cat_list.add(Category(0,'id',58727,'MaterialIcons, ','Add'));
    cat_list.add(Category(0,'id',58727,'MaterialIcons, ','Add'));
    cat_list.add(Category(0,'id',58727,'MaterialIcons, ','Add'));
    cat_list.add(Category(0,'id',58727,'MaterialIcons, ','Add'));



    color_list.add(Colors.black);
    color_list.add(Color(0xff79adff));
    color_list.add(Color(0xfff9d71c));
    color_list.add(Color(0xffff7e79));
    color_list.add(Color(0xffcf9dfd));
    color_list.add(Colors.green);
    color_list.add(Color(0xffc85509));
    color_list.add(Color(0xffea4ea3));

    _bloc.onLoading('${now.day}-${now.month}-${now.year}');

    getpercent();

  }

  List<double>  getpercent(){
    List<double> percent_list = List();
     sum=0;
    for(int i =0;i<cat_list.length;i++){
      sum +=cat_list[i].balance;
    }
  //  print('sum $sum');
    for(int i =0;i<cat_list.length;i++){
      var percent  = (cat_list[i].balance*100)/sum;
      percent_list.add(percent);
      //print('${cat_list[i].title}: $percent %');
    }
    return percent_list;
  }
  /*
  listview for user cards
   */
  Widget categoryBuilder(Stream<QuerySnapshot> _streamlist) {


    return StreamBuilder<QuerySnapshot>(
        stream: _streamlist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            final List<Category> children = snapshot.data.docs.map((doc) {
              var _card = Category.fromSnapshot(doc);

              return _card;
            }).toList();
            for(int i=0;i<children.length;i++){
              cat_list.removeAt(i);
              cat_list.insert(i, children[i]);

            }

            return Categorywidgets(cat_list);

          } else {
            return  Center(
              child: Text("No data",
                  style:  GoogleFonts.lato(textStyle:TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff314670)

                  ))
              ),
            );
          }
        });
  }

  /*
  create categories
   */
  Widget Categorywidgets(List<Category> mylist){
    return
      StreamBuilder(
        stream: Categories.Trans_Subject, //stream for transactions
        builder: (context,snapshot){
          if(snapshot.hasData){
            for(int i=0;i<mylist.length;i++){
              if(Categories.Trans_Subject.value.containsKey(mylist[i].title)){
                mylist[i].balance=Categories.Trans_Subject.value[mylist[i].title];
              }
            }
            return Column(

              children: [
                Container(
                  color: Colour.primary,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      /*
                      header date
                       */
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 4.0),
                          color: Colors.white,
                          child: Text(day,style: TextStyle(color: Colour.primary,fontWeight: FontWeight.w700,fontSize: 15.0),)),
                      SizedBox(width: 7.0,),
                      InkWell(child: Text(month_year,style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.w600)),
                      // Click on date string
                        onTap: (){
                        //  _bloc.onLoading('${now.day}-${now.month}-${now.year}');

                          DatePicker.showDatePicker(context,
                              showTitleActions: true,

                              minTime: DateTime(2018, 3, 5),
                              maxTime: DateTime(2030, 6, 7), onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                            setState(() {
                              month_year= TimeConvert.FullMonthName(date.month)+' ${date.year}';
                              day=date.day.toString();

                            });
                                _bloc.onLoading('${date.day}-${date.month}-${date.year}');
                                print('confirm ${date.year}');
                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                        },)
                    ],
                  ),
                ),
                /*
          category icons
           */

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.0,vertical: 11.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(child: CategoryWidget(mylist[0],color_list[0]) ,),
                      InkWell(child: CategoryWidget(mylist[1],color_list[1]) ,),
                      InkWell(child: CategoryWidget(mylist[2],color_list[2]),),
                      InkWell(child: CategoryWidget(mylist[3],color_list[3]) ,),

                    ],
                  ),
                ),
                /*
          Circle stats
           */
                Container(

                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width/2,

                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width/2,
                        child: CustomPaint(
                          painter: OpenPainter(color_list, getpercent()),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text('${sum.toString()}\$',
                              style: GoogleFonts.lato(textStyle:TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffef3038)

                              )),),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ),
                /*
          second category icons
           */
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryWidget(mylist[4],color_list[4]),
                      CategoryWidget(mylist[5],color_list[5]),
                      CategoryWidget(mylist[6],color_list[6]),
                      CategoryWidget(mylist[7],color_list[7]),

                    ],
                  ),
                ),
              ],
            );
          }else{
            return Container();
          }
        },
      );
  }



  /*
  input forms for category
   */
  Widget inputs() {
    return Column(
      children: [
        /*
                categroy title
                 */
        Container(
          margin: EdgeInsets.only(top: 15.0),

          //padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 6.0),
          padding: EdgeInsets.only(
            top: 3.0,
            right: 6.0,
            left: 6.0,
          ),
          child: Material(
            elevation: 9.0,
            shadowColor: Color(0xffe6e7f6),
            color: Colors.white,
            borderRadius: BorderRadius.circular(7.0),
            child: TextField(
              onChanged:(value) {
                cat_title_controller.text=value;
              },
              controller: cat_title_controller,
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              decoration: InputDecoration(
                  hintText: 'Category title',
                  hintStyle: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w500)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.white, width: 0.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.white, width: 0.0))),
            ),
          ),
        ),
        SizedBox(height: 33.0,),
        Container(
          padding: EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Text('Choose icon: ',style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),),
              SizedBox(width: 13.0,),
              //  Icon(Icons.add_circle_outline,size: 30.0,)
              StreamBuilder(
                stream: Total_Subject,
                builder: (context,snapshot){
                  return InkWell(child:Total_Subject.value,
                    onTap: _pickIcon,);
                }

              )
            ],
          ),
        )


      ],
    );
  }

  /*
  pick icon for creating new category
   */
  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(context);

    //_icon = Icon(icon);
    _icon = Icon(icon,size: 30.0);
    Total_Subject.add(_icon);
    // setState((){
    //   _icon = Icon(icon,size: 30.0);
    // });

    print('Picked Icon:  $icon');
    var tt=  IconDataToMap(icon);
    print('Icon data:  ${tt.toString()}');
  }
  /*
  create new category
   */
  Widget AddNewCategory(var context){
    return Container(
      color: Colour.bottomsheet_background,
      height: MediaQuery.of(context).size.height / 1.55,
      padding: EdgeInsets.only(
        top: 15.0,
        left: 12.0,
        right: 12.0,
      ),
      //  padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 12.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Add new category',
            style: GoogleFonts.lato(
                textStyle:
                TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600)),
          ),
          inputs(),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 20.0),
            child: MaterialButton(
              padding: EdgeInsets.symmetric(vertical: 9.0, horizontal: 24.0),
              color: Colour.primary,
              child: Text(
                "Add category",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),

              onPressed: () {


              //  _addcard_bloc.onNewCardEvent(card_title_controller.text,card_balance_controller.text);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    color: Color(0xffffffff),
      //padding: EdgeInsets.symmetric(vertical: 9.0),

      child:BlocBuilder<GetCategorylistBloc,GetCategoryListState>(
        cubit: _bloc,
        builder: (context,state){
          if(state is LoadingGetCardList){
            return Center(child: CircularProgressIndicator());
          }else if(state is RetrivedCategoryList){
            return categoryBuilder(state.cardlist);
          }else return Container();
        },
      )

    );
  }
}

class OpenPainter extends CustomPainter {

  List<Color> color_list = List();
  List<double> percents =List();

  OpenPainter(this.color_list, this.percents);
  var sum = 0.0;
  var current_percent = 0.0;
  var paint2;
  @override
  void paint(Canvas canvas, Size size) {
    var _size = size.width/2;
    sum = 0.0;
    current_percent = 0.0;
    for(int i=0;i<color_list.length;i++){
       paint2 = Paint()
        ..color = color_list[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth=(5.0);
      current_percent = percents[i]*0.0629;
      canvas.drawArc(Offset(size.width/4, 0.0) & Size(_size, _size),
         sum, //radians
          current_percent, //radians
          false,
          paint2);
      sum+=current_percent;
    }
   // print('sum: $sum');
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
