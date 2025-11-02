extends Node2D

var golisano_stench = move.new("golisano_stench", "Poison", 100, "Special", 10, 100);
var virus_spread = move.new("virus_spread", "Electric", 70, "Special", 15, 100);
var celsius_overdose = move.new("celsius_overdose", "Electric", 90, "Physical", 10, 90)
var no_maidens = move.new("no_maidens", "Ground", 80, "Physical", 10, 95)

const TYPE : Array[String] = ["Electric", "Ground"];

const MOCKMON_NAME = "Hacker";

const MAX_HP = 90; # base stats
const BASE_ATK = 50;
const BASE_DEF = 70;
const BASE_SPEC_ATK = 130;
const BASE_SPEC_DEF = 110;
const BASE_SPEED = 5;

const WEAKNESSES: Array[String] = ["Water", "Ground", "Grass", "Ice"];
const RESISTANCES: Array[String] = ["Rock","Flying", "Poison", "Steel"];
const IMMUNITIES: Array[String] = ["Electric"];

var moves: Array[move];

var currentHp = MAX_HP;
var death: bool = false;

func _ready() -> void:
	moves = [golisano_stench, virus_spread, celsius_overdose, no_maidens];

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
