extends Node2D

var present_theft = move.new("present_theft", "Dark", 666, "Physical", 1, 66);
var ninth_circle = move.new("ninth_circle", "Ice", 99, "Special", 9, 99)
var extinction = move.new("extinction", "Dark", 80, "Special", 10, 100)
var mind_control = move.new("mind_control", "Psychic", 60, "Special", 15, 85)

const TYPE : Array[String] = ["Ice", "Dark"];

const MOCKMON_NAME = "krampus";

const MAX_HP = 50; # base stats
const BASE_ATK = 1;
const BASE_DEF = 20;
const BASE_SPEC_ATK = 155;
const BASE_SPEC_DEF = 20;
const BASE_SPEED = 120;

const WEAKNESSES: Array[String] = ["Fighting", "Steel", "Fire", "Fairy", "Bug", "Rock"];
const RESISTANCES: Array[String] = ["Ice", "Ghost", "Dark"];
const IMMUNITIES: Array[String] = ["Psychic"];

var moves: Array[move];
var currentHp = MAX_HP;
var death: bool = false;

func _ready() -> void:
	moves = [present_theft, ninth_circle, extinction, mind_control];

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
