
//part of '../bloc/addcard_bloc.dart';

//@immutable
import 'package:equatable/equatable.dart';

abstract class AddCategoryState extends Equatable{


  const AddCategoryState();
}
class InitialAddCategory extends AddCategoryState{
  const InitialAddCategory();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class LoadingAddCategory extends AddCategoryState{
  const LoadingAddCategory();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class SentAddCategory extends AddCategoryState{
  const  SentAddCategory();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class ErrorAddCategory extends AddCategoryState{
  const ErrorAddCategory();

  @override
  // TODO: implement props
  List<Object> get props => [];


}
class DeleteCategory extends AddCategoryState{
  const DeleteCategory();

  @override
  // TODO: implement props
  List<Object> get props => [];


}