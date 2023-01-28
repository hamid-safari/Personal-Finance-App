import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_finance/model/card.dart';
import 'package:personal_finance/util/colour.dart';
import 'package:google_fonts/google_fonts.dart';

class CardWidget extends StatelessWidget {
  Cards _card;

  CardWidget(this._card);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 12.0,right: 12.0,top: 11.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: SvgPicture.asset('image/credit.svg',width: 40.0,height: 45.0,),
               // child: Icon(Icons.add,color: Colors.white,size: 30.0,),
                padding: EdgeInsets.all(3.0),
                // decoration: BoxDecoration(
                //   color: Colors.redAccent,
                //     border: Border.all(
                //       color: Colors.redAccent,
                //     ),
                //     borderRadius: BorderRadius.all(Radius.circular(6))
                // ),
              ),
              SizedBox(width: 13.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_card.title,
                  style: GoogleFonts.lato(textStyle:TextStyle(
                    fontSize: 18.0,

                  ))),
                  SizedBox(height: 9.0,),
                  Text("${_card.balance}",
                      style:GoogleFonts.lato(textStyle:TextStyle(
                        fontSize: 16.0,

                      ))),
                ],
              )
            ],
          )
          ,SizedBox(height: 7.0,),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colour.grey_div,
            height: 1.1,
            margin: EdgeInsets.only(left: 30.0),
          )
        ],
      ),
    );
  }
}
