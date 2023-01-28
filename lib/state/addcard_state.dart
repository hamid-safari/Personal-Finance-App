
//part of '../bloc/addcard_bloc.dart';

//@immutable
import 'package:equatable/equatable.dart';

abstract class AddCardState extends Equatable{


  const AddCardState();
}
class InitialAddCard extends AddCardState{
  const InitialAddCard();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class LoadingAddCard extends AddCardState{
  const LoadingAddCard();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class SentAddCard extends AddCardState{
  const  SentAddCard();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class ErrorAddCard extends AddCardState{
  const ErrorAddCard();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class DeleteCard extends AddCardState{
  const DeleteCard();

  @override
  // TODO: implement props
  List<Object> get props => [];


}