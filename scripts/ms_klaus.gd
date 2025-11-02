extends Node2D

var gingerbread_army = move.new("gingerbread_army", "Ground", 70, "Physical", 10, 100)
var snow_bunny_mind_control = move.new("snow_bunny_mind_control", "Psychic", 130, "Special", 5, 75)
var elf_legion = move.new("elf_legion", "Grass", 80, "Special", 15, 100)
var klausrot = move.new("klausrot", "Psychic", 75, "Special", 15, 100)

const TYPE : Array[String] = ["Psychic"];

const MOCKMON_NAME = "Mrs. Klaus";
const MAX_HP = 100; 
const BASE_ATK = 100;
const BASE_DEF = 30;
const BASE_SPEC_ATK = 110;
const BASE_SPEC_DEF = 100;
const BASE_SPEED = 30;

const WEAKNESSES: Array[String] = ["Ghost", "Dark", "Bug"];
const RESISTANCES: Array[String] = ["Fighting", "Psychic"];
const IMMUNITIES: Array[String] = [];

var moves: Array[move];

var currentHp = MAX_HP;
var death: bool = false;

func _ready() -> void:
	moves = [gingerbread_army, snow_bunny_mind_control, elf_legion, klausrot];

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
		damage = Globals.calculate_damage(enemy_atk, BASE_SPEC_DEF, move_used.power, move_used.type, WEAKNESSES, RESISTANCES, IMMUNITIES);
	elif move_used.is_category("physical"):
		damage = Globals.calculate_damage(enemy_atk, BASE_DEF, move_used.power, move_used.type, WEAKNESSES, RESISTANCES, IMMUNITIES);
	
	currentHp -= damage;
	
	if currentHp <= 0:
		death = true;
