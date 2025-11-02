extends Node2D

var one_inch_punch = move.new("one_inch_punch", "Fighting", 1000000000, "Physical", 5, 10);
var fin_flail = move.new("fin_flail", "Water", 80, "Physical", 10, 100);
var poseidons_splash = move.new("poseidons_splash", "Water", 125, "Special", 5, 70);
var aquatic_beatdown = move.new("aquatic_beatdown", "Fighting", 95, "Special", 10, 90);

const TYPE : Array[String] = ["Water", "Fighting"];

const MOCKMON_NAME = "A Buff Carp";
const MOCKMON_SPRITE = preload("res://sprites/BuffCarp.png");


const MAX_HP = 50; # base stats
const BASE_ATK = 130;
const BASE_DEF = 60;
const BASE_SPEC_ATK = 125;
const BASE_SPEC_DEF = 40;
const BASE_SPEED = 109;

const WEAKNESSES: Array[String] = ["Flying", "Grass", "Psychic", "Fairy", "Electric"];
const RESISTANCES: Array[String] = ["Rock", "Bug", "Steel", "Fire", "Water", "Ice", "Dark"];
const IMMUNITIES: Array[String] = [];

var moves: Array[move];

var currentHp = MAX_HP;
var death: bool = false;
func _ready() -> void:
	moves = [one_inch_punch, fin_flail, poseidons_splash, aquatic_beatdown];

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
