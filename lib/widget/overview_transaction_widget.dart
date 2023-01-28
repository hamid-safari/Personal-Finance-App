import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/model/weektrasn.dart';

class OverviewTransaction extends StatelessWidget {
  WeekTrans _weekTrans;

  OverviewTransaction(this._weekTrans);
  var percentage;
  @override
  Widget build(BuildContext context) {
    percentage = _weekTrans.percent/100.0;
    return Container(

      child: Column(
        children: [

          Row(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(left: 12.0,top: 15.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffedf2f7),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffd7d7d6),
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                      offset: Offset(1.0, 1.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: FittedBox(child: Text(_weekTrans.title,
                  style: GoogleFonts.lato(textStyle:TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600

                  )) ,),

                  fit: BoxFit.contain,),
              ),

              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 4.0,),
                   Container(
                     child: LinearPercentIndicator(
                      width: 220.0,

                     // width: MediaQuery.of(context).size.width/2,
                       lineHeight: 17.0,
                       percent: percentage,
                       backgroundColor: Color(0xffd8edff),
                       progressColor: Color(0xff1d95ff),
                       center: Text('${_weekTrans.percent.roundToDouble()}%'),
                     ),
                   )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 10.0),
                  child: Text('${_weekTrans.price} \$',
                      style:  GoogleFonts.lato(textStyle:TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff314670)

                      ))),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
