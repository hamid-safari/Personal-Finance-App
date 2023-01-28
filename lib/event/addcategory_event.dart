
abstract class AddcategoryEvent{}

class  NewcategoryEvent extends AddcategoryEvent{}
class  NewcategoryInit extends AddcategoryEvent{}
class NewCategoryEventError extends AddcategoryEvent{}
class NewcategoryEventSuccess extends AddcategoryEvent{}

class DeletecategoryEvent extends AddcategoryEvent{}
class DeletecategoryEventSuccesfull extends AddcategoryEvent{}
class UpdatecategoryEventSuccesfull extends AddcategoryEvent{}