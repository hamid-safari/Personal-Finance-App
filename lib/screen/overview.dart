import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:personal_finance/bloc/addcard_bloc.dart';
import 'package:personal_finance/bloc/getoverview_bloc.dart';
import 'package:personal_finance/event/addcard_event.dart';
import 'package:personal_finance/model/weektrasn.dart';
import 'package:personal_finance/state/addcard_state.dart';
import 'package:personal_finance/state/gettransaction_state.dart';
import 'package:personal_finance/widget/overview_transaction_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class Overview extends StatefulWidget {
  static BehaviorSubject<HashMap<int,int>> TransDaily_Subject = BehaviorSubject<HashMap<int,int>>();
  static BehaviorSubject<HashMap<String,int>> Transweekly_Subject = BehaviorSubject<HashMap<String,int>>();
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

var _bloc = GetOverviewBloc();
List<SalesData> translist = List();
List<WeekTrans> weeklylist = List();

var sum;
@override
void initState() {
  _bloc.onLoading();
}

@override
  Widget build(BuildContext context) {
    return Container(
          child: BlocBuilder<GetOverviewBloc,GetTransactionListState>(
            cubit: _bloc,
            builder: (context,state){
              if(state is LoadingGetTransactionList || state is InitialGetTransactionList){
                return CircularProgressIndicator();

              }else if(state is RetrivedTransactionList){
                return SingleChildScrollView(

                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      /*
                      chart section
                       */
                      Container(
                        margin: EdgeInsets.only(top: 15.0,left: 12.0),
                        alignment: Alignment.topLeft,
                        child: Text('Weekly stat',
                        style:  GoogleFonts.lato(textStyle:TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff314670)

                        )),),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15.0,horizontal: 12.0),
                        height: 250.0,
                        child: StreamBuilder(
                          stream: Overview.TransDaily_Subject,
                          builder: (context,snapshot){
                            if(snapshot.hasData ){
                              return TransChart();
                            }else{
                              return Container(child: Text(''),);
                            }
                          },
                        ),
                      ),
                      /*
                      trans category section
                       */
                      Container(
                        child: StreamBuilder(
                          stream: Overview.Transweekly_Subject,
                          builder: (context,snapshot){
                            if(snapshot.hasData ){
                              return Translist();
                            }else{
                              return Container(child: Text(''),);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10.0,)
                      
                    ],
                  ),

                );

              }

              else if(state is EmptyTransactionList){
                return Center(
                  child: Text('There is no transactions'),
                );
              }else {
                return Center(
                  child: Text('Error'),
                );
              }
            },
          )
    );
  }
  Widget Translist(){
  sum=0;
  weeklylist.clear();
    Overview.Transweekly_Subject.value.entries.forEach((element) {
      WeekTrans flag = WeekTrans(element.key.toString(), element.value,0.0);
   //   print("day: ${flag.year} - price: ${flag.sales}");
      weeklylist.add(flag);
    });

    // get sum of prices
    for(int i=0;i<weeklylist.length;i++){
              sum=sum+weeklylist[i].price;
    }
    //calcute percent for each index
  for(int i=0;i<weeklylist.length;i++){
    var percent  = (weeklylist[i].price*100)/sum;
    weeklylist[i].percent=percent;
  }

  return  Container(
     // height: 800.0,
    margin: EdgeInsets.only(bottom: 10.0),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,

          itemCount: weeklylist.length,
          itemBuilder: (context, index) {
            return  OverviewTransaction(weeklylist[index],

            );
          }),

  );
  }

  Widget TransChart(){
  print("---TransChart---");
  translist.clear();
  Overview.TransDaily_Subject.value.entries.forEach((element) {
    SalesData flag = SalesData(element.key.toString(), element.value.toDouble());
    print("day: ${flag.year} - price: ${flag.sales}");
    translist.add(flag);
  });
  // for(int i=0;i<Overview.TransDaily_Subject.value.length;i++){
  //   SalesData temp = SalesData(TransDaily_Subject.value[index], )
  // }
  //return Container(child: Text(translist[0].sales.toString()),);
    return  SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<SalesData, String>>[
          LineSeries<SalesData, String>(
            // Bind data source
              dataSource:translist ,
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales
          )
        ]
    );

    //return Container(child: Text('Chartt'),);
  }
}
class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;

  factory SalesData.fromJson(Map<String, dynamic> parsedJson) {
    return SalesData(
      parsedJson['year'].toString(),
      parsedJson['sales'] as double,
    );
  }
  }
