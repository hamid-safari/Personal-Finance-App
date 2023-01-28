
abstract class AddTransactionEvent{}

class  NewTransactionEvent extends AddTransactionEvent{}
class  NewTransactionInit extends AddTransactionEvent{}
class NewTransactionEventError extends AddTransactionEvent{}
class NewTransactionEventSuccess extends AddTransactionEvent{}

