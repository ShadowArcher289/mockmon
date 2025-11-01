extends Object
class_name move

var type : String; 
var power : int = 0;
var category : String;
var pp : int;
var accuracy : int; # > 100 is always hits

## Create a new move (Type, AtkDmg, Category, PP, Accuracy);
func _init(input_type: String, input_power: int, input_category: String, input_pp: int, input_accuracy: int) -> void:
	self.type = input_type;
	self.power = input_power;
	self.category = input_category;
	self.pp = input_pp;
	self.accuracy = input_accuracy;
	
func is_category(input_category : String): ## Check if this move's category matches the given category, ignoring case
	return input_category.to_lower() == category.to_lower();
