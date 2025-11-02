extends Node2D
class_name Mockmon

var mockmon_name : String;
var sprite : String
var type : Array[String]
var max_hp : int
var base_atk : int 
var base_def : int
var base_spec_atk : int
var base_spec_def : int
var base_speed : int
var weaknesses : Array[String]
var resistances : Array[String]
var immunities : Array[String]
var moves : Array[move]
var current_hp : int

## Create a new move (Type, AtkDmg, Category, PP, Accuracy);
func _init(input_name : String, input_sprite : String, input_type : Array[String], input_max_hp : int, input_base_atk : int, input_base_def : int, input_base_spec_atk: int, input_base_spec_def: int, input_speed :int, input_weaknesses : Array[String], input_resistances : Array[String], input_immunities : Array[String], input_moves : Array[move], input_current_hp : int ) -> void:
	self.mockmon_name = input_name;
	self.sprite = input_sprite;
	self.type = input_type;
	self.max_hp = input_max_hp;
	self.base_atk = input_base_atk;
	self.base_def = input_base_def;
	self.base_spec_atk = input_base_spec_atk;
	self.base_spec_def = input_base_spec_def;
	self.base_speed = input_speed;
	self.weaknesses = input_weaknesses;
	self.resistances = input_resistances;
	self.immunities = input_immunities;
	self.moves = input_moves;
	self.current_hp = input_current_hp;
	
func use_move(move_number: int, target: Node2D): ## Use a move on a given target given the move number
	var target_move = moves[move_number-1];
	if target.has_method("take_damage"):
		if target_move.is_category("special"):
			target.take_damage(base_spec_atk, target_move);
		elif target_move.is_category("physical"):
			target.take_damage(base_atk, target_move);

func get_move(move_number: int): ## Returns the mockmon's move
	return moves[move_number-1];

func take_damage(enemy_atk: int, move_used: move): ## The Mockmon takes damage
	var damage = 0;
	if move_used.is_category("special"):
		damage = Globals.calculate_damage(enemy_atk, base_spec_def, move_used.power, move_used.type, weaknesses, resistances, immunities);
	elif move_used.is_category("physical"):
		damage = Globals.calculate_damage(enemy_atk, base_def, move_used.power, move_used.type, weaknesses, resistances, immunities);
	
	current_hp -= damage;
	
	if current_hp <= 0:
		pass;
