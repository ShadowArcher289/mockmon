extends Node2D

var pocket_knife = move.new("Pocket Knife", "Steel", 100000000, "Physical", 1, 20);
var alley_jump = move.new("Alley Jump", "Dark", 50, "Physical", 15, 100);
var pickpocket = move.new("Pickpocket", "Normal", 80, "Physical", 10, 95);
var flash = move.new("Flash", "Psychic", 100, "Special", 10, 80);

const TYPE : Array[String] = ["Normal", "Dark"];

const MOCKMON_NAME = "A Guy In a Cloak";
const MOCKMON_SPRITE = preload("res://sprites/GuyInACloak.png");

const MAX_HP = 80; # base stats
const BASE_ATK = 80;
const BASE_DEF = 110;
const BASE_SPEC_ATK = 40;
const BASE_SPEC_DEF = 120;
const BASE_SPEED = 20;

const WEAKNESSES: Array[String] = ["Water", "Ground", "Grass", "Fighting", "Steel"];
const RESISTANCES: Array[String] = ["Normal", "Flying", "Poison", "Fire"];
const IMMUNITIES: Array[String] = ["Ghost", "Psychic"];

var moves: Array[move];

var currentHp = MAX_HP;
var death: bool = false;

func _ready() -> void:
	moves = [pocket_knife, alley_jump, pickpocket, flash];

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
