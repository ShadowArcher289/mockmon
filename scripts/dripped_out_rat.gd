extends Node2D
var fling_drip = move.new("Fling Drip", "Steel", 40, "Physical", 10, 90);
var sick_burn = move.new("Sick Burn", "Fire", 30, "Special", 20, 100);
var do_a_flip = move.new("Do A Flip", "Psychic", 40, "Special", 10, 90);
var aura_farm = move.new("Aura Farm", "Fire", 80, "Physical", 10, 90);

const TYPE : Array[String] = ["Steel", "Fire"];

const MOCKMON_NAME = "A Dripped Out Rat";
const MOCKMON_SPRITE = preload("res://sprites/DrippedOutRat.png");

const MAX_HP = 120; # base sats
const BASE_ATK = 10;
const BASE_DEF = 20;
const BASE_SPEC_ATK = 30;
const BASE_SPEC_DEF = 30;
const BASE_SPEED = 50;

const WEAKNESSES: Array[String] = ["Water", "Ground", "Fighting"];
const RESISTANCES: Array[String] = ["Normal", "Flying", "Psychic", "Dragon"];
const IMMUNITIES: Array[String] = ["Poison"];

var moves: Array[move];

var currentHp = MAX_HP;

func _ready() -> void:
	moves = [fling_drip, sick_burn, do_a_flip, aura_farm];

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
