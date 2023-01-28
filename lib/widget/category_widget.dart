import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:personal_finance/bloc/addcard_bloc.dart';
import 'package:personal_finance/bloc/addcard_bloc.dart';
import 'package:personal_finance/bloc/addcard_bloc.dart';
import 'package:personal_finance/bloc/addcategory_bloc.dart';
import 'package:personal_finance/bloc/addtransaction_bloc.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/screen/transaction_screen.dart';
import 'package:personal_finance/serialize/iconserialize.dart';
import 'package:personal_finance/state/addcategory_state.dart';
import 'package:personal_finance/util/colour.dart';
import 'package:rxdart/rxdart.dart';

class CategoryWidget extends StatefulWidget {
  Category _category;
  Color _color;

  CategoryWidget(this._category, this._color);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  Icon _icon;
  var cat_title_controller = TextEditingController();
  var _bloc;
  var _bloc_transaction =AddTransactionBloc();
  static BehaviorSubject<Icon> icon_subject = BehaviorSubject<Icon>();

  @override
  void initState() {
    _bloc =AddCategoryBloc(context);
    // _bloc = AddCategoryBloc();
    // print("inittttttttt");
  // print("codePoint: ${widget._category.codepoint}");
    _icon = Icon(
      Icons.add_circle_outline,
      size: 35.0,
    );
    icon_subject.add(_icon);
  }

  IconData Makeicon() {
    return IconData(widget._category.codepoint,
        fontFamily:
            widget._category.fontFamily.replaceFirst(RegExp(r"\,[^]*"), ""));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        /*
        Delete category
         */
        onLongPress: (){
          if(widget._category.title.toString().compareTo("Add") != 0){
            icon_subject.add(Icon(
              Icons.add_circle_outline,
              size: 35.0,
            ));
            cat_title_controller.clear();
            showMaterialModalBottomSheet(
              // expand: true,
              context: context,
              builder: (context) => DeleteCateory(context),
            );
          }
        },
        onTap: () {
          if (widget._category.title.toString().compareTo("Add") == 0) {
            // same strings
            icon_subject.add(Icon(
              Icons.add_circle_outline,
              size: 35.0,
            ));
            cat_title_controller.clear();
            showMaterialModalBottomSheet(
              // expand: true,
              context: context,
              builder: (context) => AddNewCategory(context),
            );
          } else {
            //not same

            Navigator.push(context, MaterialPageRoute(builder: (context)=>TransActionScreen(widget._category)));
          }
        },
        child: Column(
          children: [
            Text(
              widget._category.title,
              style: TextStyle(fontSize: 17.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration:
                  BoxDecoration(color: widget._color, shape: BoxShape.circle),
              child: Icon(
                Makeicon(),
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              widget._category.balance.toString(),
              style: TextStyle(fontSize: 15.0, color: widget._color),
            ),
          ],
        ),
      ),
    );
  }

  /*
  delete category form
   */
  Widget DeleteCateory(var context){

    return Container(
        color: Colour.bottomsheet_background,
        height: MediaQuery.of(context).size.height / 1.8,
    padding: EdgeInsets.only(
    top: 15.0,
    left: 12.0,
    right: 12.0,
    )
        ,child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Remove category',
          style: GoogleFonts.lato(
              textStyle:
              TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
        ),
        BlocBuilder<AddCategoryBloc, AddCategoryState>(
          cubit: _bloc,
          builder: (context, state) {
            if (state is LoadingAddCategory) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 35.0),
                child: CircularProgressIndicator(),
              );
            } else if (state is SentAddCategory) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 35.0),
                child: Text("Done...",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff19ad78)))),
              );
            }  else if (state is InitialAddCategory) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Delete category: ",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                                color: Colour.black))),
                    SizedBox(width: 7.0,),
                    Text("${widget._category.title}",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                                color: Colour.primary)))
                  ],
                ) ,
              );
            } else {
              return Container();
            }
          },
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10.0),
          child: MaterialButton(
            padding: EdgeInsets.symmetric(vertical: 9.0, horizontal: 24.0),
            color: Colour.primary,
            child: Text(
              "Delete",
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
            onPressed: () {
            //  var tt = IconDataToMap(icon_subject.value.icon);
            //  print(tt.toString());

              _bloc.onDelete(widget._category.id);
              //  _addcard_bloc.onNewCardEvent(card_title_controller.text,card_balance_controller.text);
            },
          ),
        ),
      ],
    ),
    );
  }
  /*
  add category form
   */
  Widget AddNewCategory(var context) {
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
          BlocBuilder<AddCategoryBloc, AddCategoryState>(
            cubit: _bloc,
            builder: (context, state) {
              if (state is LoadingAddCategory) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 35.0),
                  child: CircularProgressIndicator(),
                );
              } else if (state is SentAddCategory) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 35.0),
                  child: Text("Done...",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff19ad78)))),
                );
              } else if (state is ErrorAddCategory) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 35.0),
                  child: Text("Error...",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffff5466)))),
                );
              } else if (state is InitialAddCategory) {
                return Container(
                  child: inputs(),
                );
              } else {
                return Container();
              }
            },
          ),
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
                var tt = IconDataToMap(icon_subject.value.icon);
                print(tt.toString());
                _bloc.onNewcategoryEvent(cat_title_controller.text,
                    tt['codePoint'], tt['fontFamily']);
                //  _addcard_bloc.onNewCardEvent(card_title_controller.text,card_balance_controller.text);
              },
            ),
          ),
        ],
      ),
    );
  }

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
              onChanged: (value) {
                //   cat_title_controller.text=value;
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
        SizedBox(
          height: 33.0,
        ),
        Container(
          padding: EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Text(
                'Choose icon: ',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ),
              SizedBox(
                width: 13.0,
              ),
              //  Icon(Icons.add_circle_outline,size: 30.0,)
              StreamBuilder(
                  stream: icon_subject,
                  builder: (context, snapshot) {
                    return InkWell(
                      child: icon_subject.value,
                      onTap: _pickIcon,
                    );
                  })
            ],
          ),
        )
      ],
    );
  }

  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(context);

    //_icon = Icon(icon);
    _icon = Icon(icon, size: 30.0);
    icon_subject.add(_icon);
    // setState((){
    //   _icon = Icon(icon,size: 30.0);
    // });

    print('Picked Icon:  $icon');
    var tt = IconDataToMap(icon);
    print('Icon data:  ${tt.toString()}');
  }
}
