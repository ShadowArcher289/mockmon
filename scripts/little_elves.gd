extends Node2D

var on_a_shelf = move.new("on_a_shelf", "Normal", 88, "Physical", 10, 100)
var on_a_belt = move.new("on_a_belt", "Normal", 55, "Physical", 10, 100)
var in_a_hat = move.new("in_a_hat", "Normal", 77, "Physical", 10, 100)
var in_a_bath = move.new("in_a_bath", "Grass", 100, "Physical", 5, 100)
const TYPE : Array[String] = ["Normal", "Grass"];

const MOCKMON_NAME = "Little Elves";

const MAX_HP = 130; # base stats
const BASE_ATK = 50;
const BASE_DEF = 150;
const BASE_SPEC_ATK = 1;
const BASE_SPEC_DEF = 150;
const BASE_SPEED = 1;

const WEAKNESSES: Array[String] = ["Fighting", "Fire", "Bug", "Flying", "Poison", "Ice"];
const RESISTANCES: Array[String] = ["Electric", "Water", "Ground"];
const IMMUNITIES: Array[String] = ["Ghost"];

var moves: Array[move];
var currentHp = MAX_HP;
var death: bool = false;

func _ready() -> void:
	moves = [on_a_shelf, on_a_belt, in_a_hat, in_a_bath];

func use_move(move_choice: move, target: Node2D): ## Use a move on a given target given a move 
	if target.has_method("take_damage"):
		if move_choice.is_category("special"):
			target.take_damage(BASE_SPEC_ATK, move_choice);
		elif move_choice.is_category("physical"):
			target.take_damage(BASE_ATK, move_choice);


func get_move(move_number: int): ## Returns the mockmon's move
	return moves[move_number-1];

func take_damage(enemy_atk: int, move_used: move): ## The Mockmon takes damage
	var damage = 0;
	if move_used.is_category("special"):
		damage = Globals.calculate_damage(enemy_atk, BASE_SPEC_DEF, move_used.power, move_used.type, WEAKNESSES, RESISTANCES, IMMUNITIES, move_used.accuracy);
	elif move_used.is_category("physical"):
		damage = Globals.calculate_damage(enemy_atk, BASE_DEF, move_used.power, move_used.type, WEAKNESSES, RESISTANCES, IMMUNITIES, move_used.accuracy);
	
	currentHp -= damage;
	
	if currentHp <= 0:
		death = true;
