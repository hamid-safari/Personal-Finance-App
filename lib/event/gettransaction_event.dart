abstract class GetTransactionEvent{}

class GetTransactionListSuccess extends GetTransactionEvent{}
class LoadingTransactionListEvent extends GetTransactionEvent{}
class GetTransactionListErrorEvent extends GetTransactionEvent{}
class GetTransactionListInit extends GetTransactionEvent{}