import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:personal_finance/model/card.dart';

abstract class GetCardListState extends Equatable{
  const GetCardListState();
}

class InitialGetCardList extends GetCardListState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class LoadingGetCardList extends GetCardListState{
  const LoadingGetCardList();
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class RetrivedGetCardList extends GetCardListState{
  Stream<QuerySnapshot> cardlist;

  RetrivedGetCardList(this.cardlist);
  @override
  // TODO: implement props
  List<Object> get props => [cardlist];

}
class EmptyCardList extends GetCardListState{
  const EmptyCardList();
  @override
  // TODO: implement props
  List<Object> get props => [];

}