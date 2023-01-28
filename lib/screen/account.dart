import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:personal_finance/bloc/addcard_bloc.dart';
import 'package:personal_finance/bloc/getcardlist_bloc.dart';
import 'package:personal_finance/model/card.dart';
import 'package:personal_finance/state/addcard_state.dart';
import 'package:personal_finance/state/getcardlist_state.dart';
import 'package:personal_finance/util/colour.dart';
import 'package:personal_finance/widget/cardlist_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:personal_finance/serialize/iconserialize.dart';

class Account extends StatefulWidget {
  //final TotalBalanceCallback _totalBalanceCallback;
  static BehaviorSubject<int> Total_Subject = BehaviorSubject<int>();
  static List<Cards> Cardlist=List();
  //Account(this._totalBalanceCallback);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var _bloc = GetCardlistBloc();
  var _addcard_bloc = AddCardBloc();
  var total_balance = 0;
  var flag_update = false;
  var card_title_controller = TextEditingController();
  var card_balance_controller = TextEditingController();

  final firestoreInstance = FirebaseFirestore.instance.collection("cards");

  @override
  void initState() {
    _bloc.onLoading();

    var icon = Icons.add_circle_outline;
    var temp = IconDataToMap(icon);
    print(temp);

   
  }

  /*
  listview for user cards
   */
  Widget cardlistwidget(Stream<QuerySnapshot> _streamlist) {

    print("-----------cardlistwidget");
    return StreamBuilder<QuerySnapshot>(
        stream: _streamlist,
        builder: (context, snapshot) {
          Account.Cardlist.clear();
          if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
            total_balance = 0;
            Account.Cardlist = snapshot.data.docs.map((doc) {
              var _card = Cards.fromSnapshot(doc);
              total_balance += _card.balance;
              print("totla: $total_balance");
              return _card;
            }).toList();
            /*
            update first screen ui to display total balance in header
             */
            print("final totla: $total_balance");
            // widget._totalBalanceCallback(total_balance);
            Account.Total_Subject.add(total_balance);
            return Container(
              child: ListView.builder(
                  itemCount: Account.Cardlist.length,
                  itemBuilder: (context, index) {
                    return InkWell(child: CardWidget(Account.Cardlist[index]),
                      onTap: (){
                      flag_update=false;
                        showMaterialModalBottomSheet(
                          // expand: true,
                          context: context,
                          builder: (context) => EditCard(Account.Cardlist[index].title,Account.Cardlist[index].balance,Account.Cardlist[index].id),
                        );
                      },
                    );
                  }),
            );
          } else {
            return Center(
              child: Text("Do not have any card",
                  style:  GoogleFonts.lato(textStyle:TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff314670)

                  ))),
            );
          }
        });
  }

  /*
  Edit card
   */
  Widget EditCard(var title_card,balance_card,var doc_id) {
    if(flag_update==false){
      card_title_controller.text =title_card;
      card_balance_controller.text=balance_card.toString();

    }
      flag_update=true;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add new card',
                  style: GoogleFonts.lato(
                      textStyle:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600)),
                ),
                InkWell(

                  onTap: (){
                    print(
                        "card details: ${card_title_controller.text} - $doc_id");
                    _addcard_bloc.onDelete(doc_id);
                  },
                  child:Icon(Icons.delete_forever,size: 38.0,
                    color: Color(0xffff5466),),
                  // child:SvgPicture.asset('image/trash.svg',height: 40.0,) ,
                )
              ],
            ),
            BlocBuilder<AddCardBloc, AddCardState>(
              cubit: _addcard_bloc,
              builder: (context, state) {
                if (state is LoadingAddCard) {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 35.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SentAddCard) {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 35.0),
                    child: Text("Done...",
                        style:GoogleFonts.lato(textStyle:TextStyle(
                            fontSize: 18.0,

                            fontWeight: FontWeight.bold,
                            color: Color(0xff19ad78)
                        ))),
                  );
                }
                else if(state is DeleteCard){
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 35.0),
                    child: Text("Removed...",
                        style:GoogleFonts.lato(textStyle:TextStyle(
                            fontSize: 18.0,

                            fontWeight: FontWeight.bold,
                            color: Color(0xff19ad78)
                        ))),
                  );
                }
                else if (state is ErrorAddCard) {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 35.0),
                    child: Text("Error...",
                        style:GoogleFonts.lato(textStyle:TextStyle(
                            fontSize: 18.0,

                            fontWeight: FontWeight.bold,
                            color: Color(0xffff5466)
                        ))),
                  );
                } else {
                  return Container(
                    child: inputs(),
                  );
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
                  "Edit card",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
                onPressed: () {
                  print(
                      "card details: ${card_title_controller.text} - ${card_balance_controller.text}");
                  _addcard_bloc.onUpdateCardEventSuccesfull(card_title_controller.text,card_balance_controller.text,doc_id);
                },
              ),

            ),
          ],
        ),
      );


  }

  /*
    Add new Card widget
     */
  Widget inputs() {
    return Column(
      children: [
        /*
                card title
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
                card_title_controller.text=value;

         //       monMorOp.text = validateTimeFormat(value);
                card_title_controller.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: card_title_controller.text.length));

              },
              controller: card_title_controller,
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
              decoration: InputDecoration(
                  hintText: 'Card title',
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

        /*
                card balance
                 */
        Container(
          margin: EdgeInsets.only(top: 15.0),
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 6.0),
          child: Material(
            elevation: 9.0,
            shadowColor: Color(0xffe6e7f6),
            color: Colors.white,
            borderRadius: BorderRadius.circular(7.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: card_balance_controller,
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              decoration: InputDecoration(
                  hintText: 'Card balance',
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
      ],
    );
  }

  /*
  add new card bottomsheet
   */
  Widget AddnewCard() {
   // card_title_controller.clear();
    //card_balance_controller.clear();

    print("clickeddddd");
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
            'Add new card',
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600)),
          ),
          BlocBuilder<AddCardBloc, AddCardState>(
            cubit: _addcard_bloc,
            builder: (context, state) {
              if (state is LoadingAddCard) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 35.0),
                  child: CircularProgressIndicator(),
                );
              } else if (state is SentAddCard) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 35.0),
                  child: Text("Card Added succesfully...",
                      style:GoogleFonts.lato(textStyle:TextStyle(
                        fontSize: 18.0,

                          fontWeight: FontWeight.bold,
                          color: Color(0xff19ad78)
                      ))),
                );
              } else if (state is ErrorAddCard) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 35.0),
                  child: Text("Error...",
                      style:GoogleFonts.lato(textStyle:TextStyle(
                          fontSize: 18.0,

                          fontWeight: FontWeight.bold,
                          color: Color(0xffff5466)
                      ))),
                );
              } else {
                return Container(
                  child: inputs(),
                );
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
                "Save card",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
              onPressed: () {

                print(
                    "card details: ${card_title_controller.text} - ${card_balance_controller.text}");
                _addcard_bloc.onNewCardEvent(card_title_controller.text,card_balance_controller.text);
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
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
              width: MediaQuery.of(context).size.width,
              child: Text('All accounts',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 18.0, color: Colour.black),
                  ))),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  BlocBuilder<GetCardlistBloc, GetCardListState>(
                      cubit: _bloc,
                      builder: (context, state) {
                        if (state is RetrivedGetCardList) {
                          print("retriv called");
                          return cardlistwidget(state.cardlist);
                        } else if (state is InitialGetCardList ||
                            state is LoadingGetCardList) {
                          return CircularProgressIndicator();
                        } else {
                          return Center(
                            child: Text('You do not have any card...'),
                          );
                        }
                      }),
                  Positioned(
                    child: FloatingActionButton(
                      child: Text(
                        '+',
                        style: TextStyle(fontSize: 40.0),
                      ),
                      onPressed: () {
                        print("Float button");
                        card_title_controller.clear();
                        card_balance_controller.clear();

                        showMaterialModalBottomSheet(
                          // expand: true,
                          context: context,
                          builder: (context) => AddnewCard(),
                        );
                      },
                    ),
                    bottom: 12.0,
                    right: 12.0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef TotalBalanceCallback = int Function(int);
