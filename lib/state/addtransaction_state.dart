
//part of '../bloc/addcard_bloc.dart';

//@immutable
import 'package:equatable/equatable.dart';

abstract class AddTransactionState extends Equatable{


  const AddTransactionState();
}
class InitialAddTransaction extends AddTransactionState{
  const InitialAddTransaction();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class LoadingAddTransaction extends AddTransactionState{
  const LoadingAddTransaction();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class SentAddTransaction extends AddTransactionState{
  const  SentAddTransaction();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class ErrorAddTransaction extends AddTransactionState{
  const ErrorAddTransaction();

  @override
  // TODO: implement props
  List<Object> get props => [];


}