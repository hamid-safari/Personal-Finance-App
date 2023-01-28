import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_finance/model/transaction.dart';

class TransactionWidget extends StatelessWidget {
  Transactions transactions;

  TransactionWidget(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        children: [

          Row(
            children: [
              Container(
                width: 65.0,
                height: 65.0,
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(left: 12.0,top: 15.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffedf2f7)
                ),
                child: FittedBox(child: Text(transactions.category,
                style: GoogleFonts.lato(textStyle:TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600

                )) ,),

                  fit: BoxFit.contain,),
              ),

              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(transactions.title,
                          textAlign: TextAlign.left,
                        style:  GoogleFonts.lato(textStyle:TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          color: Color(0xff314670)

                        )),),
                      ),
                    SizedBox(height: 4.0,),
                    Text(transactions.fulldate,
                      textAlign: TextAlign.left,
                      style:  GoogleFonts.lato(textStyle:TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff314670)

                      )),),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 10.0),
                  child: Text('${transactions.price} \$',
                      style:  GoogleFonts.lato(textStyle:TextStyle(
                          fontSize: 18.0,
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
