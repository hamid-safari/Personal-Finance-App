import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:personal_finance/model/card.dart';

abstract class GetTransactionListState extends Equatable{
  const GetTransactionListState();
}

class InitialGetTransactionList extends GetTransactionListState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class LoadingGetTransactionList extends GetTransactionListState{

  @override
  // TODO: implement props
  List<Object> get props => [];

}
class RetrivedTransactionList extends GetTransactionListState{
  Stream<QuerySnapshot> translist;

  RetrivedTransactionList(this.translist);
  @override
  // TODO: implement props
  List<Object> get props => [translist];

}
class EmptyTransactionList extends GetTransactionListState{
  const EmptyTransactionList();
  @override
  // TODO: implement props
  List<Object> get props => [];

}