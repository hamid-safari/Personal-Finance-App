
// part of '../bloc/addcard_bloc.dart';


//@immutable
abstract class AddcardEvent{}

  class  NewCardEvent extends AddcardEvent{}
  class  NewCardInit extends AddcardEvent{}
class NewCardEventError extends AddcardEvent{}
class NewCardEventSuccess extends AddcardEvent{}

class DeleteCardEvent extends AddcardEvent{}
class DeleteCardEventSuccesfull extends AddcardEvent{}
class UpdateCardEventSuccesfull extends AddcardEvent{}