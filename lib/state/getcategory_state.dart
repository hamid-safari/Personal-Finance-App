import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:personal_finance/model/card.dart';

abstract class GetCategoryListState extends Equatable{
  const GetCategoryListState();
}

class InitialGetCategoryList extends GetCategoryListState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class LoadingGetCardList extends GetCategoryListState{
  const LoadingGetCardList();
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class RetrivedCategoryList extends GetCategoryListState{
  Stream<QuerySnapshot> cardlist;

  RetrivedCategoryList(this.cardlist);
  @override
  // TODO: implement props
  List<Object> get props => [cardlist];

}
class EmptyCategoryList extends GetCategoryListState{
  const EmptyCategoryList();
  @override
  // TODO: implement props
  List<Object> get props => [];

}