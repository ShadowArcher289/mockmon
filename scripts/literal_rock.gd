extends Node2D
var rock_slam = move.new("Rock", 40, "Physical", 15, 100);
var intimidating_stare = move.new("Psychic", 10, "Special", 20, 100);
var rock_throw = move.new("Rock", 60, "Physical", 15, 90);
var what_rocks_do = move.new("Rock", 0, "Physical", 30, 80);

var moves: Array[move] = [];

const TYPE : Array[String] = ["Rock"];

const MAX_HP = 120; # base sats
const BASE_ATK = 10;
const BASE_DEF = 20;
const BASE_SPEC_ATK = 30;
const BASE_SPEC_DEF = 30;
const BASE_SPEED = 50;

const WEAKNESSES: Array[String] = ["Water", "Ground", "Grass", "Fighting", "Steel"];
const RESISTANCES: Array[String] = ["Normal", "Flying", "Poison", "Fire"];
const IMMUNITIES: Array[String] = [];

var currentHp = MAX_HP;

func _ready() -> void:
	moves = [rock_slam, intimidating_stare, rock_throw, what_rocks_do];

func use_move(move_number: int, target: Node2D): ## Use a move on a given target given the move number
	var target_move = moves[move_number-1];
	if target.has_method("take_damage"):
		if target_move.is_category("special"):
			target.take_damage(BASE_SPEC_ATK, target_move);
		elif target_move.is_category("physical"):
			target.take_damage(BASE_ATK, target_move);

func get_move(move_number: int): ## Returns the mockmon's move
	return moves[move_number-1];

func take_damage(enemy_atk: int, move_used: move): ## The Mockmon takes damage
	var damage = 0;
	if move_used.is_category("special"):
		damage = Globals.calculate_damage(enemy_atk, BASE_SPEC_DEF, move_used.power, move_used.type, WEAKNESSES, RESISTANCES, IMMUNITIES);
	elif move_used.is_category("physical"):
		damage = Globals.calculate_damage(enemy_atk, BASE_DEF, move_used.power, move_used.type, WEAKNESSES, RESISTANCES, IMMUNITIES);
	
	currentHp -= damage;
	
	if currentHp <= 0:
		pass;
