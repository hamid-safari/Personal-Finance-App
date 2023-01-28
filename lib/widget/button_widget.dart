import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/screen/transaction_screen.dart';
import 'package:personal_finance/util/colour.dart';

class ButtonWidget extends StatelessWidget {
  var price;
  var color;
  var current_price;
  var temp;
 // Transactions transactions;
  BlocCallback blocCallback;
  ButtonWidget(this.price,{this.color,this.blocCallback});
var padding=18.0;
  Widget check_child(){
    if (price is String){
      return Text(price,
        style: GoogleFonts.lato(
            textStyle:
            TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700,color: Colors.black)),);
    }else{
      return price;
    }
  }
  double padding_size(){
    if (price is String){
      color=Colors.white;
      padding=18.0;

    }else{
      padding=5.0;
    }
    return padding;
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if (price is String){
          if(TransActionScreen.Price_Subject.value<999999999){
            temp = int.parse(price);
            current_price = TransActionScreen.Price_Subject.value*10;
            current_price+=temp;
            TransActionScreen.Price_Subject.add(current_price);
          }

        }else if(price.icon ==Icons.remove){
          current_price = TransActionScreen.Price_Subject.value/10;

         TransActionScreen.Price_Subject.add(current_price.toInt());
        }else{
          print("result: ${TransActionScreen.Price_Subject.value}");
          //TransActionScreen.bloc.onNewcategoryEvent(transactions);
          blocCallback();
        }

      },
      child: Container(
       // height: 40.0,
      // width: 50.0,
        padding: EdgeInsets.all(padding_size()),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xffd7d7d6),
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(1.0, 1.0), // shadow direction: bottom right
            )
          ],
        ),
        child: check_child()
      ),
    );
  }
}
typedef BlocCallback = void Function();
