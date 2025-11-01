extends Object
class_name move

var type : String; 
var atk_damage : int = 0;
var category : String;
var pp : int;
var accuracy : int; # > 100 is always hits

## Create a new move (Type, AtkDmg, Category, PP, Accuracy);
func _init(input_type: String, input_atk_damage: int, input_category: String, input_pp: int, input_accuracy: int) -> void:
	self.type = input_type;
	self.atk_damage = input_atk_damage;
	self.category = input_category;
	self.pp = input_pp;
	self.accuracy = input_accuracy;
	
